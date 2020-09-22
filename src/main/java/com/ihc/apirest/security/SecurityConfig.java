package com.ihc.apirest.security;

import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;

@EnableWebSecurity
public class SecurityConfig extends WebSecurityConfigurerAdapter 
{
	
    protected void configure(HttpSecurity http) throws Exception 
    {
		 http.authorizeRequests()
		 .antMatchers("/public").permitAll()
		 .antMatchers("/home").hasRole("ADMIN")
		 .antMatchers("/api/").hasRole("USER")
		 .and().csrf().disable()
		 .logout()
		 .and()		 
         .formLogin();
	}
}