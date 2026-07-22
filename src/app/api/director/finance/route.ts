import { DirectorService } from '@/features/director/director.service';
import { successResponse, errorResponse } from '@/lib/api-response';
import { getSession } from '@/lib/auth';
export async function GET() {
    try { return successResponse(await DirectorService.getFinanceRecords()); }
    catch (e: any) { return errorResponse('Failed', 500, e.message); }
}
export async function POST(req: Request) {
    try {
        const [body, session] = await Promise.all([req.json(), getSession()]);
        return successResponse(await DirectorService.createFinanceRecord({ ...body, recorded_by: Number((session as any)?.userId || (session as any)?.id) || null }));
    }
    catch (e: any) { return errorResponse('Failed', 500, e.message); }
}
export async function PUT(req: Request) {
    try { const body = await req.json(); return successResponse(await DirectorService.updateFinanceRecord(body.id, body)); }
    catch (e: any) { return errorResponse('Failed', 500, e.message); }
}
export async function DELETE(req: Request) {
    try { const { searchParams } = new URL(req.url); return successResponse(await DirectorService.deleteFinanceRecord(Number(searchParams.get('id')))); }
    catch (e: any) { return errorResponse('Failed', 500, e.message); }
}
