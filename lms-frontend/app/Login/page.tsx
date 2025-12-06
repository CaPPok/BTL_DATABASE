"use client";

import { User, Lock, LogIn } from "lucide-react";
import { useState } from "react";
import { useRouter } from 'next/navigation';

export default function LoginPage() {
const router = useRouter();
  const [maNguoiDung, setUsername] = useState('');
  const [matKhau, setPassword] = useState('');
  const [error, setError] = useState('');

  const handleLogin = async (e: any) => {
    e.preventDefault();
    setError('');

  try {
    const res = await fetch("http://localhost:8080/api/auth/Login", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ 
          maNguoiDung: maNguoiDung, 
          matKhau: matKhau
      }),
    });

    if (res.ok) {
      const data = await res.json();
      
      // 1. Lưu thông tin user vào localStorage
      localStorage.setItem('NguoiDung', JSON.stringify(data));

      // 2. Điều hướng dựa trên Role
      if (data.role === 'SinhVien') {
        router.push('/MonHoc'); // Tạo trang này sau
      } else if (data.role === 'GiangVien') {
        router.push('/lecturer/dashboard'); // Tạo trang này sau
      } else {
        setError('Tài khoản không có quyền truy cập');
      }
    } else {
      setError('Sai tên người dùng hoặc mật khẩu!');
    }
  } catch (err: any) {
    console.error(err);
    alert("Không thể kết nối tới server!");
  }
};

  return (
    
    <div className="flex flex-col min-h-screen text-center bg-gradient-to-br from-amber-200 via-orange-100 to-pink-300">
      <main
        className="flex flex-col items-center justify-center flex-grow bg-cover bg-center bg-no-repeat text-center px-4"
      >
        <div className="bg-white border border-amber-200 rounded-2xl shadow-lg w-full max-w-md px-8 py-10 text-left">
          <h3 className="text-2xl font-semibold text-center text-amber-600 mb-6">
            Đăng nhập tài khoản
          </h3>

          {/* --- ĐÂY LÀ PHẦN HIỂN THỊ LỖI --- */}
          {error && (
            <div className="mb-4 p-3 bg-red-100 border border-red-400 text-red-700 rounded text-sm text-center">
              {error}
            </div>
          )}
          {/* ------------------------------- */}

          <form onSubmit={handleLogin} className="space-y-5">
            <div>
              <label className="block text-gray-600 font-medium mb-2">
                Tên đăng nhập
              </label>
              <div className="flex items-center border border-gray-300 rounded-lg px-3 py-2 focus-within:ring-2 focus-within:ring-amber-300">
                <User size={18} className="text-gray-500 mr-2" />
                <input
                  type="text"
                  placeholder="Nhập tên đăng nhập"
                  value={maNguoiDung}
                  onChange={(e) => setUsername(e.target.value)}
                  className="w-full outline-none"
                  required
                />
              </div>
            </div>

            <div>
              <label className="block text-gray-600 font-medium mb-2">
                Mật khẩu
              </label>
              <div className="flex items-center border border-gray-300 rounded-lg px-3 py-2 focus-within:ring-2 focus-within:ring-amber-300">
                <Lock size={18} className="text-gray-500 mr-2" />
                <input
                  type="password"
                  placeholder="Nhập mật khẩu"
                  value={matKhau}
                  onChange={(e) => setPassword(e.target.value)}
                  className="w-full outline-none"
                  required
                />
              </div>
            </div>
            <button
              type="submit"
              onClick={handleLogin}
              className="w-full bg-orange-300 hover:bg-orange-400 text-white py-2.5 rounded-lg font-semibold transition-all cursor-pointer"
            >
              Đăng nhập
            </button>
          </form>
        </div>
      </main>
    </div>
  );
}
