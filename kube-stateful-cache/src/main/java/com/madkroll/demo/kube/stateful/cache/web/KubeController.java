package com.madkroll.demo.kube.stateful.cache.web;

import com.madkroll.demo.kube.stateful.cache.service.KubeCacheService;
import lombok.extern.log4j.Log4j2;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

/**
 * Controller publishing endpoint to handle AdditionalData requests.
 */
@CrossOrigin(
        origins = "*",
        methods = {RequestMethod.GET, RequestMethod.OPTIONS}
)
@RequestMapping("/kube")
@RestController
@Log4j2
public class KubeController {

    private final KubeCacheService kubeCache;

    public KubeController(final KubeCacheService kubeCache) {
        this.kubeCache = kubeCache;
    }

    @RequestMapping("/welcome")
    @GetMapping(produces = {MediaType.APPLICATION_JSON_VALUE})
    public ResponseEntity<KubeResponse> handleRequest() {
        return ResponseEntity
                .ok()
                .body(new KubeResponse(kubeCache.read()));
    }
}
