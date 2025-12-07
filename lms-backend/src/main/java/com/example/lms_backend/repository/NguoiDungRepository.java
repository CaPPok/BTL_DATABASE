package com.example.lms_backend.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.example.lms_backend.entity.NguoiDung;

public interface NguoiDungRepository extends JpaRepository<NguoiDung, String> {
}
