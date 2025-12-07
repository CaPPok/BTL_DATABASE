package com.example.lms_backend.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.lms_backend.entity.LopHoc;

@Repository
public interface LopHocRepository extends JpaRepository<LopHoc, String> {
}