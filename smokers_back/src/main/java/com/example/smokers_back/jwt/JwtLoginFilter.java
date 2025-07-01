package com.example.smokers_back.jwt;

import com.example.smokers_back.data.entity.UserEntity;
import com.example.smokers_back.data.repository.UserRepository;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

import java.io.IOException;
import java.util.*;


public class JwtLoginFilter extends UsernamePasswordAuthenticationFilter {
    private final AuthenticationManager authenticationManager;
    private final JwtUtil jwtUtil;
    private final UserRepository userRepository;

    public JwtLoginFilter(AuthenticationManager authenticationManager, JwtUtil jwtUtil, UserRepository userRepository) {
        this.authenticationManager = authenticationManager;
        this.jwtUtil = jwtUtil;
        this.userRepository = userRepository;
    }


    @Override
    public Authentication attemptAuthentication(HttpServletRequest request, HttpServletResponse response) throws AuthenticationException{
        String username = obtainUsername(request);
        String password = obtainPassword(request);
        UsernamePasswordAuthenticationToken authRequest = new UsernamePasswordAuthenticationToken(username, password, null);
        return authenticationManager.authenticate(authRequest);
    }

    @Override
    public void successfulAuthentication(HttpServletRequest request, HttpServletResponse response, FilterChain chain, Authentication authResult) throws IOException, ServletException {
        UserDetails userDetails = (UserDetails) authResult.getPrincipal();

        String username = userDetails.getUsername();
        Collection<? extends GrantedAuthority> grantedAuthorities = userDetails.getAuthorities();
        Iterator<? extends GrantedAuthority> iterator = grantedAuthorities.iterator();
        GrantedAuthority grantedAuthority = iterator.next();
        String role = grantedAuthority.getAuthority();

        UserEntity user = this.userRepository.findByUsername(username);

        Map<String, Object> responseData = new HashMap<>();
        responseData.put("role", role);
        responseData.put("email", user.getEmail());
        responseData.put("phone", user.getPhone());
        responseData.put("nickname", user.getNickname());
//        Set<FavoriteEntity> favorites = user.getFavorites();
//        responseData.put("favorites", favorites);
        ObjectMapper mapper = new ObjectMapper();
        String jsonMessage = mapper.writeValueAsString(responseData);

        String access_token = this.jwtUtil.createToken("access", username, role, 60 * 60 * 24 * 1000L);
        String refresh_token = this.jwtUtil.createToken("refresh", username, role, 60 * 60 * 24 * 1000L);
        response.addHeader("Authorization", "Bearer " + access_token);
        response.addCookie(this.createCookie("refresh", refresh_token));
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(jsonMessage);
    }

    @Override
    public void unsuccessfulAuthentication(HttpServletRequest request, HttpServletResponse response, AuthenticationException failed) throws IOException {
        Map<String, Object> responseData = new HashMap<>();
        responseData.put("error", "로그인 실패");

        ObjectMapper objectMapper = new ObjectMapper();
        String jsonmessage = objectMapper.writeValueAsString(responseData);

        response.setStatus(401); // HTTP 401 Unauthorized
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(jsonmessage);
    }

    private Cookie createCookie(String key, String value) {
        Cookie cookie = new Cookie(key, value);
        cookie.setPath("/"); //// 루트 경로부터 시작되는 모든 요청에 대해 쿠키가 포함되도록 설정
        cookie.setHttpOnly(true);
        cookie.setMaxAge(60 * 60 * 24);
        return cookie;
    }
}
