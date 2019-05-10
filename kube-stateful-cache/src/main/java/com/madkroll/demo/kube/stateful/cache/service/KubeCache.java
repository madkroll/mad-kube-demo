package com.madkroll.demo.kube.stateful.cache.service;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public enum KubeCache {

    REGISTERED_PODS("registeredPods");

    private final String cacheName;
}