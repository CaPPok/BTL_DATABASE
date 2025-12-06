package com.example.lms_backend.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.lms_backend.entity.MonHoc;
import com.example.lms_backend.repository.MonHocRepository;

@RestController
@RequestMapping("/api/monhoc")
@CrossOrigin(origins = "http://localhost:3000") // Cho phép Next.js gọi
public class MonHocController {
    @Autowired
    private MonHocRepository repository;

    @GetMapping
    public List<MonHoc> getAll() {
        return repository.findAll();
    }
}