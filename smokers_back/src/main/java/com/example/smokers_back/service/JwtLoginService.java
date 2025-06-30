package com.example.smokers_back.service;

import com.example.smokers_back.data.entity.UserEntity;
import com.example.smokers_back.data.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
public class JwtLoginService implements UserDetailsService {
    private final UserRepository userRepsitory;

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        UserEntity userEntity = this.userRepsitory.findByUsername(username);
        if(userEntity == null) {
            throw new UsernameNotFoundException("User not found" + username);
        }
        List<GrantedAuthority> grantedAuthorities = new ArrayList<>();
        grantedAuthorities.add(new SimpleGrantedAuthority(userEntity.getRole()));
        return new User(userEntity.getUsername(), userEntity.getPassword(), grantedAuthorities);
    }
}
