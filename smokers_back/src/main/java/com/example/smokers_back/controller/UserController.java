package com.example.smokers_back.controller;


import com.example.smokers_back.data.dto.UserDTO;
import com.example.smokers_back.data.entity.UserEntity;
import com.example.smokers_back.data.repository.UserRepository;
import com.example.smokers_back.service.UserService;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;

@RestController
@RequiredArgsConstructor
public class UserController {
    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final UserService userService;

    @PostMapping(value = "/join")
    public ResponseEntity<String> join(@RequestBody UserDTO userDTO) {
        if(this.userRepository.existsByUsername(userDTO.getUsername())) {
            return new ResponseEntity<>("Username already exists", HttpStatus.CONFLICT);
        }
        UserEntity authEntity = UserEntity.builder()
                .username(userDTO.getUsername())
                .password(this.passwordEncoder.encode(userDTO.getPassword()))
                .role("ROLE_USER")
                .email(userDTO.getEmail())
                .phone(userDTO.getPhone())
                .nickname(userDTO.getNickname())
                .build();
        this.userRepository.save(authEntity);
        return ResponseEntity.status(HttpStatus.OK).body("가입성공");
    }

    @PostMapping(value = "/logout1")
    public ResponseEntity<String> logout(HttpServletRequest request, HttpServletResponse response) {
        Cookie cookie = new Cookie("refresh", null);
        cookie.setMaxAge(0);
        cookie.setPath("/");
        cookie.setHttpOnly(true);
        response.addCookie(cookie);
        return ResponseEntity.status(HttpStatus.OK).body("refresh token deleted");
    }

    @GetMapping(value="/user/{username}")
    public ResponseEntity<UserDTO> findUserByUsername(@PathVariable String username) {
        UserDTO userDTO=userService.findUserByUsername(username);
        if(userDTO==null) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(userDTO);
    }

    @PutMapping(value="/user/modify")
    public ResponseEntity<UserDTO> modifyUser(@RequestBody UserDTO userDTO) {
        UserDTO modified=userService.modifyUser(userDTO);
        if(modified==null) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(modified);
    }
}
