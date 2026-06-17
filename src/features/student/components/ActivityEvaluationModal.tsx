"use client";

import { useState } from "react";
import Portal from "@/components/Portal";
import { StudentApiService } from "@/services/student-api.service";
import toast from "react-hot-toast";

interface ActivityEvaluationModalProps {
    open: boolean;
    activity: any;
    year: number;
    semester: number;
    onClose: () => void;
    onSubmit: () => void;
}

export default function ActivityEvaluationModal({
    open,
    activity,
    year,
    semester,
    onClose,
    onSubmit
}: ActivityEvaluationModalProps) {
    const [submitting, setSubmitting] = useState(false);
    const [feedback, setFeedback] = useState("");

    if (!open || !activity) return null;

    const handleSubmit = async () => {
        try {
            setSubmitting(true);
            
            // Dummy data for now, real implementation would have dynamic form fields
            const data = [
                { name: "ความพึงพอใจโดยรวม", value: 5 }
            ];

            await StudentApiService.submitActivityEvaluation({
                activity_id: activity.id,
                year,
                semester,
                data,
                feedback
            });

            toast.success("ส่งแบบประเมินเรียบร้อยแล้ว");
            onSubmit();
        } catch (error: any) {
            toast.error(error.message || "เกิดข้อผิดพลาดในการส่งแบบประเมิน");
        } finally {
            setSubmitting(false);
        }
    };

    return (
        <Portal>
            <div className="fixed inset-0 z-[9999] flex items-center justify-center p-4 bg-slate-900/60 backdrop-blur-sm">
                <div className="bg-white rounded-2xl w-full max-w-md p-6 shadow-xl relative overflow-hidden">
                    <button 
                        onClick={onClose}
                        className="absolute top-4 right-4 p-2 text-slate-400 hover:text-slate-600 rounded-full hover:bg-slate-100 transition-colors"
                        disabled={submitting}
                    >
                        <svg className="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" />
                        </svg>
                    </button>
                    
                    <div className="mb-6 pr-8">
                        <h2 className="text-xl font-bold text-slate-800">ประเมินกิจกรรม</h2>
                        <p className="text-slate-500 text-sm mt-1">{activity.title || activity.name}</p>
                    </div>

                    <div className="space-y-4">
                        <div className="bg-pink-50 text-pink-700 p-4 rounded-xl text-sm font-medium border border-pink-100">
                            (รอแบบฟอร์มประเมินที่สมบูรณ์) ระบบจะบันทึกว่าคุณประเมินกิจกรรมนี้ด้วยคะแนนความพึงพอใจ 5 ดาว
                        </div>

                        <div>
                            <label className="block text-sm font-bold text-slate-700 mb-2">ข้อเสนอแนะเพิ่มเติม (ถ้ามี)</label>
                            <textarea 
                                value={feedback}
                                onChange={(e) => setFeedback(e.target.value)}
                                className="w-full border border-slate-200 rounded-xl p-3 text-sm focus:ring-2 focus:ring-red-500 focus:border-transparent outline-none transition-all resize-none min-h-[100px]"
                                placeholder="พิมพ์ข้อเสนอแนะของคุณ..."
                            />
                        </div>
                    </div>

                    <div className="mt-6 flex justify-end gap-3">
                        <button 
                            onClick={onClose}
                            disabled={submitting}
                            className="px-4 py-2 text-slate-600 font-bold bg-slate-100 hover:bg-slate-200 rounded-lg transition-colors text-sm"
                        >
                            ยกเลิก
                        </button>
                        <button 
                            onClick={handleSubmit}
                            disabled={submitting}
                            className="px-6 py-2 bg-red-600 hover:bg-red-700 text-white font-bold rounded-lg transition-colors shadow-md text-sm flex items-center gap-2 disabled:opacity-70"
                        >
                            {submitting ? (
                                <>
                                    <div className="w-4 h-4 border-2 border-white/30 border-t-white rounded-full animate-spin" />
                                    กำลังบันทึก...
                                </>
                            ) : (
                                "ยืนยันการประเมิน"
                            )}
                        </button>
                    </div>
                </div>
            </div>
        </Portal>
    );
}
