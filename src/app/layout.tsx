import './globals.css';
import Providers from '@/components/Providers';

export const metadata = {
    title: 'Ban Khlong Nong Lek School',
    description: 'ระบบจัดการโรงเรียน Ban Khlong Nong Lek School - ตรวจสอบเกรด ตารางเรียน สุขภาพ และอื่นๆ',
    manifest: '/manifest.json',
    appleWebApp: {
        capable: true,
        statusBarStyle: 'default',
        title: 'Ban Khlong Nong Lek School',
    },
};

export const viewport = {
    themeColor: '#DB2777',
};

export default function RootLayout({
    children,
}: {
    children: React.ReactNode;
}) {
    return (
        <html lang="th">
            <body className="bg-slate-50 min-h-screen text-slate-800">
                <Providers>
                    {children}
                </Providers>
            </body>
        </html>
    );
}
