"use client";
import { useState, useEffect, useMemo } from "react";
import { TeacherApiService } from "@/services/teacher-api.service";

export function AttendanceFeature({ session }: { session: any }) {
    const [classrooms, setClassrooms] = useState<any[]>([]);
    const [selectedClassroomId, setSelectedClassroomId] = useState<number | "">("");
    const [date, setDate] = useState(new Date().toISOString().slice(0, 10));
    const [students, setStudents] = useState<any[]>([]);
    const [statusMap, setStatusMap] = useState<Record<number, string>>({});
    const [loading, setLoading] = useState(true);
    const [saving, setSaving] = useState(false);

    useEffect(() => {
        setLoading(true);
        TeacherApiService.getAdvisorClassrooms(session.id)
            .then(d => {
                setClassrooms(d || []);
                if (d && d.length > 0) {
                    setSelectedClassroomId(d[0].classroom_id);
                }
                setLoading(false);
            })
            .catch((err) => {
                console.error("Failed to fetch advisor classrooms:", err);
                setLoading(false);
            });
    }, [session.id]);

    const selectedClassroomInfo = useMemo(() => {
        return classrooms.find(c => c.classroom_id === selectedClassroomId);
    }, [selectedClassroomId, classrooms]);

    const isComplete = useMemo(() => {
        return students.length > 0 && students.every(s => !!statusMap[s.student_id]);
    }, [students, statusMap]);

    const remainingCount = useMemo(() => {
        return students.length - Object.keys(statusMap).length;
    }, [students, statusMap]);

    const loadAttendance = async () => {
        if (!selectedClassroomId) return;
        setLoading(true);
        try {
            const data = await TeacherApiService.getAttendanceStudents(session.id, selectedClassroomId, date);
            setStudents(data || []);
            const map: Record<number, string> = {};
            (data || []).forEach((s: any) => {
                if (s.status) map[s.student_id] = s.status;
            });
            setStatusMap(map);
        } catch (error) {
            console.error("Failed to load attendance list:", error);
        } finally {
            setLoading(false);
        }
    };

    useEffect(() => {
        if (selectedClassroomId) {
            loadAttendance();
        } else {
            setStudents([]);
            setStatusMap({});
        }
    }, [selectedClassroomId, date]);

    const handleSave = async () => {
        if (!selectedClassroomId) return;
        if (!isComplete) {
            alert(`กรุณาเช็คชื่อให้ครบทุกคน (ยังเหลืออีก ${remainingCount} คน)`);
            return;
        }
        setSaving(true);
        try {
            const records = students.map(s => ({
                student_id: s.student_id,
                classroom_id: selectedClassroomId,
                date,
                status: statusMap[s.student_id]
            }));
            await TeacherApiService.saveAttendance(records);
            alert("บันทึกเช็คชื่อเรียบร้อย!");
        } catch (error: any) {
            alert("เกิดข้อผิดพลาด: " + (error.message || error));
        } finally {
            setSaving(false);
        }
    };

    const handleClearAttendance = () => {
        if (Object.keys(statusMap).length > 0 && confirm("ล้างการเช็คชื่อที่เลือกไว้ทั้งหมดในห้องเรียนนี้?")) {
            setStatusMap({});
        }
    };

    const statusOptions = [
        { value: "present", label: "มา", color: "bg-green-100 text-green-700 border-green-300" },
        { value: "absent", label: "ขาด", color: "bg-red-100 text-red-700 border-red-300" },
        { value: "late", label: "สาย", color: "bg-amber-100 text-amber-700 border-amber-300" },
        { value: "leave", label: "ลา", color: "bg-sky-100 text-sky-700 border-sky-300" },
    ];

    return (
        <div className="space-y-6">
            <section className="bg-gradient-to-br from-emerald-600 to-teal-700 rounded-3xl p-8 text-white shadow-lg relative overflow-hidden">
                <div className="absolute top-0 right-0 w-64 h-full bg-white opacity-5 transform -skew-x-12 translate-x-20"></div>
                <div className="relative z-10">
                    <div className="inline-block bg-white/20 px-3 py-1 rounded-full text-sm font-medium mb-4">Attendance</div>
                    <h1 className="text-3xl font-bold flex items-center gap-2">
                        <svg className="w-8 h-8" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2" />
                        </svg>
                        เช็คชื่อนักเรียนประจำชั้น (Homeroom)
                    </h1>
                    {selectedClassroomInfo ? (
                        <div className="mt-2 text-emerald-100 text-sm opacity-90 leading-relaxed">
                            <div>ระดับชั้น: {selectedClassroomInfo.label}</div>
                            <div>ประจำวันที่: {date}</div>
                        </div>
                    ) : (
                        <p className="text-emerald-100 mt-2">เช็คชื่อนักเรียนประจำชั้นและบันทึกสถานะการเข้าเรียนประจำวัน</p>
                    )}
                </div>
            </section>

            {classrooms.length === 0 && !loading ? (
                <div className="bg-white rounded-3xl p-8 text-center border border-slate-200 shadow-sm max-w-lg mx-auto mt-8">
                    <div className="w-16 h-16 bg-amber-50 text-amber-500 rounded-full flex items-center justify-center mx-auto mb-4">
                        <svg className="w-8 h-8" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" />
                        </svg>
                    </div>
                    <h3 className="text-lg font-bold text-slate-800 mb-2">ไม่พบห้องเรียนในที่ปรึกษา</h3>
                    <p className="text-sm text-slate-500">บัญชีของคุณไม่ได้ถูกบันทึกเป็นครูที่ปรึกษาของห้องเรียนใดๆ ในภาคเรียนนี้ หากคิดว่าเป็นข้อผิดพลาด กรุณาติดต่อผู้ดูแลระบบ</p>
                </div>
            ) : (
                <>
                    <div className="bg-white rounded-2xl p-5 shadow-sm border border-slate-200 flex flex-wrap gap-4 items-end">
                        <div className="flex-1 min-w-[200px]">
                            <label className="text-xs text-slate-500 font-medium block mb-1">ระดับชั้นประจำชั้น</label>
                            <select
                                className="w-full px-4 py-2 border border-slate-200 rounded-xl outline-none"
                                value={selectedClassroomId}
                                onChange={e => setSelectedClassroomId(e.target.value === "" ? "" : Number(e.target.value))}
                            >
                                <option value="">เลือกระดับชั้น</option>
                                {classrooms.map(c => (
                                    <option key={c.classroom_id} value={c.classroom_id}>
                                        {c.label}
                                    </option>
                                ))}
                            </select>
                        </div>
                        <div>
                            <label className="text-xs text-slate-500 font-medium block mb-1">วันที่</label>
                            <input
                                type="date"
                                className="px-4 py-2 border border-slate-200 rounded-xl outline-none"
                                value={date}
                                onChange={e => setDate(e.target.value)}
                            />
                        </div>
                    </div>

                    {selectedClassroomId && (
                        <div className="bg-white rounded-2xl shadow-sm border border-slate-200 overflow-hidden">
                            {loading ? (
                                <div className="p-8 text-center text-slate-500">กำลังโหลด...</div>
                            ) : (
                                <>
                                    <table className="w-full">
                                        <thead>
                                            <tr className="bg-slate-50 border-b border-slate-200">
                                                <th className="px-4 py-3 text-left text-sm font-medium text-slate-600 w-16 text-center">เลขที่</th>
                                                <th className="px-4 py-3 text-left text-sm font-medium text-slate-600 w-32">รหัส</th>
                                                <th className="px-4 py-3 text-left text-sm font-medium text-slate-600">ชื่อ-นามสกุล</th>
                                                <th className="px-4 py-3 text-center text-sm font-medium text-slate-600">สถานะ</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            {students.map((s, i) => {
                                                const isMarked = !!statusMap[s.student_id];
                                                return (
                                                    <tr key={s.student_id} className={`border-b border-slate-100 transition-colors ${!isMarked ? 'bg-rose-50/20' : 'hover:bg-slate-50'}`}>
                                                        <td className="px-4 py-3 text-sm text-slate-500 text-center">{i + 1}</td>
                                                        <td className="px-4 py-3 text-sm text-slate-800 tracking-tight">{s.student_code}</td>
                                                        <td className="px-4 py-3 text-sm text-slate-800">
                                                            {s.prefix}{s.first_name} {s.last_name}
                                                        </td>
                                                        <td className="px-4 py-3">
                                                            <div className="flex gap-1.5 justify-center flex-wrap">
                                                                {statusOptions.map(opt => (
                                                                    <button
                                                                        key={opt.value}
                                                                        onClick={() => setStatusMap({ ...statusMap, [s.student_id]: opt.value })}
                                                                        className={`px-4 py-1.5 rounded-lg text-sm transition-all border ${statusMap[s.student_id] === opt.value ? opt.color + ' ring-2 ring-offset-1 ring-slate-200 shadow-sm font-bold' : 'bg-white text-slate-400 border-slate-200 hover:bg-slate-50'}`}
                                                                    >
                                                                        {opt.label}
                                                                    </button>
                                                                ))}
                                                            </div>
                                                        </td>
                                                    </tr>
                                                );
                                            })}
                                        </tbody>
                                    </table>
                                    <div className="p-4 border-t border-slate-200 flex flex-wrap gap-4 justify-between items-center bg-slate-50/50">
                                        <div className="flex items-center gap-4">
                                            <span className="text-sm text-slate-600 font-medium">นักเรียนทั้งหมด {students.length} คน</span>
                                            {remainingCount > 0 ? (
                                                <span className="text-xs font-bold text-rose-500 px-2 py-1 bg-rose-50 rounded-lg">ยังขาดอีก {remainingCount} คน</span>
                                            ) : (
                                                <span className="text-xs font-bold text-emerald-600 px-2 py-1 bg-emerald-50 rounded-lg">เช็คชื่อครบแล้ว</span>
                                            )}
                                        </div>
                                        <div className="flex gap-3">
                                            <button onClick={handleClearAttendance} className="px-4 py-2.5 text-slate-500 hover:text-rose-600 font-bold text-sm transition-colors">
                                                ล้างรายการเช็คชื่อ
                                            </button>
                                            <button
                                                onClick={handleSave}
                                                disabled={saving || !isComplete}
                                                className={`px-8 py-2.5 rounded-xl font-bold transition-all flex items-center justify-center ${isComplete ? 'bg-emerald-600 text-white hover:bg-emerald-700 shadow-md active:scale-95' : 'bg-slate-200 text-slate-400 cursor-not-allowed'}`}
                                            >
                                                {saving ? (
                                                    <div className="w-4 h-4 border-2 border-white/20 border-t-white rounded-full animate-spin mr-2" />
                                                ) : null}
                                                {saving ? "กำลังบันทึก..." : "บันทึกเช็คชื่อ"}
                                            </button>
                                        </div>
                                    </div>
                                </>
                            )}
                        </div>
                    )}
                </>
            )}
        </div>
    );
}
