package ch.kodista.documentscanner;

import com.getcapacitor.JSObject;
import com.getcapacitor.NativePlugin;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;

@NativePlugin
public class DocumentScanner extends Plugin {

    @PluginMethod
    public void scan(PluginCall call) {
        call.reject("not implemented")
    }
}
