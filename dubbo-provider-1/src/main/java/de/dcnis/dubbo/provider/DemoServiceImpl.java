package de.dcnis.dubbo.provider;

import de.dcnis.api.DemoService;
import org.apache.dubbo.config.annotation.DubboService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@DubboService(version = "1.0.0")
public class DemoServiceImpl implements DemoService {

    @Autowired
    private ApplicationContext appContext;

    @Override
    public String sayHello(String name) {
        LocalDateTime time = LocalDateTime.now();
        DateTimeFormatter format = DateTimeFormatter.ofPattern("HH:mm:ss");
        System.out.println("Provider answered " + time.format(format));

        return "Hello " + name + " from Docker " + appContext.getDisplayName();
    }

}
