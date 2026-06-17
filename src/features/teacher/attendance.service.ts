import { prisma } from '@/lib/prisma';

type AttendanceRecordInput = { enrollment_id?: number; student_id?: number; status: string; remark?: string };
type UiAttendanceRecordInput = { student_id: number; classroom_id?: number; section_id?: number; date: string; status: string; remark?: string };

function formatLocalDate(date: Date) {
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const day = String(date.getDate()).padStart(2, '0');
    return `${year}-${month}-${day}`;
}

function assertEditableAttendanceDate(date: string) {
    if (date > formatLocalDate(new Date())) {
        throw new Error('attendance cannot be edited for a future date');
    }
}

export const TeacherAttendanceService = {
    async getAdvisorClassrooms(teacher_id: number) {
        const advisors = await prisma.classroom_advisors.findMany({
            where: { teacher_id },
            include: {
                classrooms: {
                    include: {
                        levels: true
                    }
                }
            }
        });

        return advisors.map(a => {
            const room = a.classrooms;
            if (!room) return null;
            return {
                classroom_id: room.id,
                class_level: room.levels?.name || '',
                room: room.room_name,
                label: room.levels?.name || '',
            };
        }).filter(Boolean);
    },

    async getAttendanceList(teacher_id: number, classroom_id: number, date: string) {
        // Get students in this classroom
        const classroomStudents = await prisma.classroom_students.findMany({
            where: { classroom_id },
            include: {
                students: {
                    include: { name_prefixes: true }
                }
            }
        });

        // Find or create attendance session for this date
        let session = await prisma.attendance_sessions.findFirst({
            where: {
                classroom_id,
                session_date: new Date(date),
            }
        });

        // Get existing records if session exists
        let existingRecords: any[] = [];
        if (session) {
            existingRecords = await prisma.attendance_records.findMany({
                where: { attendance_session_id: session.id }
            });
        }

        return classroomStudents.map(cs => {
            const student = cs.students;
            if (!student) return null;
            const record = existingRecords.find(r => r.student_id === student.id);
            return {
                student_id: student.id,
                student_code: student.student_code,
                prefix: student.name_prefixes?.prefix_name || '',
                first_name: student.first_name,
                last_name: student.last_name,
                status: record?.status || null,
                remark: record?.remark || '',
                record_id: record?.id || null,
            };
        }).filter(Boolean);
    },

    async saveAttendance(
        classroom_id: number | UiAttendanceRecordInput[],
        date?: string,
        records?: AttendanceRecordInput[]
    ): Promise<{ success: boolean; count?: number }> {
        if (Array.isArray(classroom_id)) {
            const uiRecords = classroom_id;
            if (uiRecords.length === 0) return { success: true, count: 0 };

            const grouped = new Map<string, { classroom_id: number; date: string; records: AttendanceRecordInput[] }>();
            uiRecords.forEach((r) => {
                const targetId = Number(r.classroom_id || r.section_id);
                const sessionDate = String(r.date || '').trim();
                if (!targetId || Number.isNaN(targetId)) throw new Error('classroom_id or section_id required');
                if (!sessionDate) throw new Error('date required');
                assertEditableAttendanceDate(sessionDate);

                const key = `${targetId}:${sessionDate}`;
                if (!grouped.has(key)) {
                    grouped.set(key, { classroom_id: targetId, date: sessionDate, records: [] });
                }

                grouped.get(key)?.records.push({
                    student_id: Number(r.student_id),
                    status: String(r.status || 'present'),
                    remark: r.remark,
                });
            });

            for (const group of grouped.values()) {
                await this.saveAttendanceByStudent(group.classroom_id, group.date, group.records);
            }

            return { success: true, count: uiRecords.length };
        }

        const taId = Number(classroom_id);
        if (!taId || Number.isNaN(taId)) throw new Error('classroom_id required');
        if (!date) throw new Error('date required');
        assertEditableAttendanceDate(date);
        const normalized = Array.isArray(records) ? records : [];

        return this.saveAttendanceByStudent(taId, date, normalized);
    },

    async saveAttendanceByStudent(
        classroom_id: number,
        date: string,
        records: AttendanceRecordInput[]
    ) {
        // Find or create session
        let session = await prisma.attendance_sessions.findFirst({
            where: {
                classroom_id,
                session_date: new Date(date),
            }
        });

        if (!session) {
            session = await prisma.attendance_sessions.create({
                data: {
                    classroom_id,
                    session_date: new Date(date),
                }
            });
        }

        // Upsert records
        for (const rec of records) {
            if (!rec.student_id) continue;
            const existing = await prisma.attendance_records.findFirst({
                where: {
                    attendance_session_id: session.id,
                    student_id: rec.student_id,
                }
            });

            if (existing) {
                await prisma.attendance_records.update({
                    where: { id: existing.id },
                    data: { status: rec.status, remark: rec.remark || null }
                });
            } else {
                await prisma.attendance_records.create({
                    data: {
                        attendance_session_id: session.id,
                        student_id: rec.student_id,
                        status: rec.status,
                        remark: rec.remark || null,
                    }
                });
            }
        }

        return { success: true };
    },
};
