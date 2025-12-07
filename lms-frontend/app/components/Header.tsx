'use client';

import Link from 'next/link';
import { usePathname, useRouter } from 'next/navigation';
import { Bell, MessageCircle, LogOut, User as UserIcon } from 'lucide-react';
import { useEffect, useState } from 'react';
import Image from "next/image";

interface UserInfo {
  maNguoiDung: string;
  hoTen: string;
  role: string;
}

export default function Header() {
  const pathname = usePathname();
  const router = useRouter();
  const [user, setUser] = useState<UserInfo | null>(null);

  useEffect(() => {
    // Lấy thông tin user từ localStorage khi load trang
    const stored = localStorage.getItem('NguoiDung');
    if (stored) {
      setUser(JSON.parse(stored));
    }
  }, []);

  const handleLogout = () => {
    localStorage.removeItem('NguoiDung');
    router.push('/Login');
  };

  // Xác định link "Các khóa học của tôi" dựa trên Role
  const myCoursesLink = user?.role === 'GiangVien' 
    ? '/GiangVien/LopHoc' 
    : '/SinhVien/LopHoc';

  const navItems = [
    { name: 'Trang chủ', href: '#'},
    { name: 'Bảng Điều khiển', href: '#' },
    { name: 'Các khoá học của tôi', href: myCoursesLink }, // Link động
    { name: 'BKeL Cũ', href: '#' },
    { name: 'Khóa học', href: '/MonHoc' },
  ];

  return (
    <header className="bg-[#008CBA] text-white shadow-md font-sans">
      <div className="w-full px-10 h-12 flex items-center justify-between">
        
        {/* --- LEFT: LOGO & NAV --- */}
        <div className="flex items-center h-full">
          {/* Logo BK giả lập */}
          <Link href="/" className="flex items-center justify-center mr-6 hover:opacity-90">
            <Image
            src="/logoBKwhite.png"
            alt="BK TP.HCM Logo"
            width={30}
            height={30}
            className="object-contain cursor-pointer"
            />
          </Link>

          {/* Menu Desktop */}
          <nav className="hidden md:flex h-full items-center">
            {navItems.map((item) => {
              const isActive = pathname === item.href || (item.href !== '/' && pathname.startsWith(item.href));

              return (
                <Link
                  key={item.name}
                  href={item.href}
                  className={`
                    h-full flex items-center px-3 text-[14px]
                    ${isActive 
                      ? 'bg-[#0056b3]'
                      : 'hover:bg-[#0062cc]'
                    }
                  `}
                >
                  {item.name}
                </Link>
              );
            })}
          </nav>
        </div>

        {/* --- RIGHT: USER INFO & ACTIONS --- */}
        <div className="flex items-center space-x-3">
            {/* Icons */}
            <button className="p-2 hover:bg-[#0062cc] rounded-full transition cursor-pointer">
                <Bell size={18} />
            </button>
            <button className="p-2 hover:bg-[#0062cc] rounded-full transition mr-2 cursor-pointer">
                <MessageCircle size={18} />
            </button>

            {/* User Info */}
            {user ? (
                <div className="flex items-center gap-3 pl-3 border-l border-white/20">
                    <div className="text-right hidden sm:block leading-tight">
                        <p className="text-[13px] font-bold">{user.hoTen}</p>
                        <p className="text-[11px] opacity-80">{user.maNguoiDung}</p>
                    </div>
                    
                    <div className="w-9 h-9 bg-white text-[#0073B7] rounded-full flex items-center justify-center font-bold text-sm shadow-sm">
                        {user.hoTen.charAt(0)}
                    </div>

                    <button 
                        onClick={handleLogout}
                        title="Đăng xuất"
                        className="p-2 rounded-full text-white/90 ml-1 hover:bg-[#0062cc] cursor-pointer"
                    >
                        <LogOut size={18} />
                    </button>
                </div>
            ) : (
                <Link href="/Login" className="text-sm font-bold hover:underline">
                    Đăng nhập
                </Link>
            )}
        </div>
      </div>
    </header>
  );
}