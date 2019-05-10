package com.madkroll.demo.kube.stateless.web;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public class KubeResponse {

    private final String message;
}