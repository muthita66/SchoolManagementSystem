import { getSession } from '@/lib/auth';
import Image from 'next/image';
import UserMenu from './UserMenu';
import SidebarToggleBtn from './SidebarToggleBtn';

export default async function Header() {
    const session = await getSession();

    return (
        <header className="fixed top-0 left-0 right-0 z-40 h-16 bg-white/80 backdrop-blur-md shadow-sm border-b border-slate-200 flex items-center justify-between px-4 md:px-6 transition-all duration-300">
            <div className="flex items-center gap-2 md:gap-3">
                <SidebarToggleBtn />
                <div className="h-10 w-10 rounded-full bg-white shadow-md border border-slate-200 overflow-hidden flex items-center justify-center shrink-0">
                    <Image
                        src="/school-logo.jpg"
                        alt="Ban Khlong Nong Lek School logo"
                        width={40}
                        height={40}
                        className="h-full w-full object-cover"
                        priority
                    />
                </div>
                <span className="text-lg md:text-xl font-bold bg-clip-text text-transparent bg-gradient-to-r from-pink-700 to-red-600 tracking-tight whitespace-nowrap">
                    Ban Khlong Nong Lek School
                </span>
            </div>

            <UserMenu session={session} />
        </header>
    );
}
