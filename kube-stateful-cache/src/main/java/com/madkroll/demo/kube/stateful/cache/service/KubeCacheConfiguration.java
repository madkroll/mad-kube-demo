package com.madkroll.demo.kube.stateful.cache.service;

import com.hazelcast.config.CacheSimpleConfig;
import com.hazelcast.config.Config;
import com.hazelcast.config.EvictionConfig;
import com.hazelcast.config.JoinConfig;
import com.hazelcast.config.KubernetesConfig;
import com.hazelcast.config.MulticastConfig;
import com.hazelcast.config.NetworkConfig;
import org.springframework.cache.annotation.EnableCaching;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import javax.cache.Cache;
import javax.cache.CacheManager;
import java.util.HashMap;
import java.util.Map;

@Configuration
@EnableCaching
public class KubeCacheConfiguration {

    private static final String INSTANCE_NAME = "HAZELCAST_INSTANCE_ID";

    @Bean
    public Cache<String, String> registeredPods(final CacheManager customCacheManager) {
        return customCacheManager.getCache(KubeCache.REGISTERED_PODS.getCacheName());
    }

    @Bean
    public Config hazelcastConfig() {
        final Config config = new Config();

        config.setInstanceName(INSTANCE_NAME)
                .setNetworkConfig(getNetworkConfig())
                .setCacheConfigs(getCacheConfigMap());

        return config;
    }

    private NetworkConfig getNetworkConfig() {
        final MulticastConfig multicastConfig = new MulticastConfig();
        multicastConfig.setEnabled(false);

        final KubernetesConfig kubernetesConfig = new KubernetesConfig();
        kubernetesConfig.setEnabled(true)
                .setProperty("service-name", "kube-stateful-hazelcast-service");

        final JoinConfig joinConfig = new JoinConfig();
        joinConfig.setMulticastConfig(multicastConfig);
        joinConfig.setKubernetesConfig(kubernetesConfig);

        final NetworkConfig networkConfig = new NetworkConfig();
        networkConfig.setJoin(joinConfig);

        return networkConfig;
    }

    private Map<String, CacheSimpleConfig> getCacheConfigMap() {
        final Map<String, CacheSimpleConfig> cacheConfig = new HashMap<>();

        final EvictionConfig evictionConfig = new EvictionConfig();
        evictionConfig.setSize(10000);

        final CacheSimpleConfig registeredPodsCache = new CacheSimpleConfig();
        registeredPodsCache.setName(KubeCache.REGISTERED_PODS.getCacheName());
        registeredPodsCache.setKeyType(String.class.getCanonicalName());
        registeredPodsCache.setValueType(String.class.getCanonicalName());
        registeredPodsCache.setEvictionConfig(evictionConfig);

        cacheConfig.put(registeredPodsCache.getName(), registeredPodsCache);

        return cacheConfig;
    }
}