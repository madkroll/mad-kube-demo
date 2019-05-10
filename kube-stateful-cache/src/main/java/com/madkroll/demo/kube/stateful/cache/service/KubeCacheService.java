package com.madkroll.demo.kube.stateful.cache.service;

import lombok.extern.log4j.Log4j2;
import org.springframework.stereotype.Service;

import javax.cache.Cache;
import java.net.UnknownHostException;
import java.util.UUID;
import java.util.stream.Collectors;
import java.util.stream.StreamSupport;

import static java.net.InetAddress.getLocalHost;

@Log4j2
@Service
public class KubeCacheService {

    private static final String THIS_POD_UUID = UUID.randomUUID().toString();

    private final Cache<String, String> registeredPods;

    public KubeCacheService(final Cache<String, String> registeredPods) {
        this.registeredPods = registeredPods;
        try {
            final String hostName = getLocalHost().getHostName();
            final String hostAddress = getLocalHost().getHostAddress();
            this.registeredPods.put(THIS_POD_UUID, hostName + ":" + hostAddress);
            log.info("Registered a pod: {}:{}:{}", THIS_POD_UUID, hostName, hostAddress);
        } catch (final UnknownHostException e) {
            log.error("Failed to cache pod in registry.", e);
        }
    }

    public String read() {
        return StreamSupport.stream(registeredPods.spliterator(), false)
                .map(entry -> entry.getKey() + ":" + entry.getValue())
                .collect(Collectors.joining(" | "));
    }
}