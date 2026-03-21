package com.learn.mcp;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class EcommerceApplication {

    public static void main(String[] args) {
        // Add vm option -Duser.timezone=Asia/Kolkata
        System.out.println(System.getProperty("user.timezone"));
        SpringApplication.run(EcommerceApplication.class, args);
    }
}
