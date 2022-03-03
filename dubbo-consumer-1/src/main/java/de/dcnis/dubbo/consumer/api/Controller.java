package de.dcnis.dubbo.consumer.api;

import de.dcnis.api.DemoService;
import org.apache.dubbo.config.annotation.DubboReference;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class Controller {

    @DubboReference(version = "1.0.0")
    private DemoService demoService;

    @GetMapping("/hello")
    public String getHello(){
        return demoService.sayHello("Dennis");
    }

}
