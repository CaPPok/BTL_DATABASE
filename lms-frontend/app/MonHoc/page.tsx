'use client'; // Dùng client component để fetch data
import { useEffect, useState } from 'react';
import Header from "@/app/components/Header";

export default function MonHocPage() {
  const [monHocs, setMonHocs] = useState([]);

  useEffect(() => {
    // Gọi API từ Spring Boot
    fetch('http://localhost:8080/api/monhoc')
      .then((res) => res.json())
      .then((data) => {
        setMonHocs(data); // Lưu dữ liệu vào state
      })
      .catch((error) => console.error('Lỗi kết nối:', error));
  }, []);

  return (
    <div className="">
      <Header />
      <div className="p-10">
        <h1 className="text-2xl font-bold mb-5">Danh sách Môn Học</h1>
        <ul>
          {monHocs.map((mh) => (
            <li key={mh.maMonHoc} className="border p-2 my-2 rounded shadow">
              <span className="font-bold">{mh.tenMonHoc}</span>: {mh.moTa}
            </li>
          ))}
        </ul>
      </div>
    </div>
  );
}