import { DirectorService } from '@/features/director/director.service';
import { successResponse, errorResponse } from '@/lib/api-response';
import { getSession } from '@/lib/auth';
export async function GET(req: Request) {
    try {
        const { searchParams } = new URL(req.url);
        const year = Number(searchParams.get('year')) || undefined;
        const semester = Number(searchParams.get('semester')) || undefined;
        const search = searchParams.get('search') || undefined;
        return successResponse(await DirectorService.getProjects(year, semester, search));
    } catch (e: any) { return errorResponse('Failed', 500, e.message); }
}
export async function POST(req: Request) {
    try {
        const [body, session] = await Promise.all([req.json(), getSession()]);
        return successResponse(await DirectorService.createProject({ ...body, created_by: Number((session as any)?.userId || (session as any)?.id) || null }));
    }
    catch (e: any) { return errorResponse('Failed', 500, e.message); }
}
export async function PATCH(req: Request) {
    try {
        const [body, session] = await Promise.all([req.json(), getSession()]);
        const userId = Number((session as any)?.userId || (session as any)?.id) || undefined;
        return successResponse(await DirectorService.changeProjectStatus(Number(body.id), body.action, userId, body.note));
    } catch (e: any) { return errorResponse('Failed', 500, e.message); }
}
export async function PUT(req: Request) {
    try { const body = await req.json(); return successResponse(await DirectorService.updateProject(body.id, body)); }
    catch (e: any) { return errorResponse('Failed', 500, e.message); }
}
export async function DELETE(req: Request) {
    try { const { searchParams } = new URL(req.url); return successResponse(await DirectorService.deleteProject(Number(searchParams.get('id')))); }
    catch (e: any) { return errorResponse('Failed', 500, e.message); }
}
