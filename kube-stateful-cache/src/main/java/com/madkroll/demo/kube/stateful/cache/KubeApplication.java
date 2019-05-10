package com.madkroll.demo.kube.stateful.cache;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
@SuppressWarnings("checkstyle:hideutilityclassconstructor")
public class KubeApplication {

    public static void main(final String[] args) {
        SpringApplication.run(KubeApplication.class, args);
    }
}
