package de.dcnis.dubbo.provider;

import de.dcnis.api.DemoService;
import org.apache.dubbo.config.annotation.DubboService;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@DubboService(version = "1.0.0")
public class DemoServiceImpl implements DemoService {

    private final int appId = (int) (Math.random() * 1000000000);

    @Override
    public String sayHello(String name) {
        LocalDateTime time = LocalDateTime.now();
        DateTimeFormatter format = DateTimeFormatter.ofPattern("HH:mm:ss");
        System.out.println("Provider answered " + time.format(format));

        return "Hello " + name + " from Docker " + appId;
    }

}
