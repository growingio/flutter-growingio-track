package com.growingio.plugin.fluttergrowingiotrack;

import android.text.TextUtils;

import androidx.annotation.NonNull;

import com.growingio.android.sdk.collection.ErrorLog;
import com.growingio.android.sdk.collection.GrowingIO;
import com.growingio.android.sdk.utils.LogUtil;
import com.growingio.android.sdk.utils.ThreadUtils;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.HashMap;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/** FlutterGrowingIOTrackPlugin */
public class FlutterGrowingIOTrackPlugin implements FlutterPlugin, MethodCallHandler {

  private MethodChannel channel;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "flutter_growingio_track");
    channel.setMethodCallHandler(this);
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }

  @Override
  public void onMethodCall(@NonNull final MethodCall call, @NonNull final Result result) {
    ThreadUtils.runOnUiThread(new Runnable() {
      @Override
      public void run() {
        onUIMethodCall(call, result);
      }
    });
  }

  private void onUIMethodCall(MethodCall call, Result result) {
    if (call.method.equals("track")) {
      onTrack(call);
    } else if (call.method.equals("setEvar")) {
      onSetEvar(call);
    } else if (call.method.equals("setPeopleVariable")) {
      onSetPeopleVariable(call);
    } else if (call.method.equals("setUserId")) {
      onSetUserId(call);
    } else if (call.method.equals("clearUserId")) {
      onClearUserId();
    } else if (call.method.equals("setVisitor")) {
      onSetVisitor(call);
    } else {
      result.notImplemented();
      return;
    }
    result.success(null);
  }

  private void onSetEvar(MethodCall call) {
    GrowingIO.getInstance().setEvar(toJson((call.arguments)));
  }

  private void onSetPeopleVariable(MethodCall call) {
    GrowingIO.getInstance().setPeopleVariable(toJson(call.arguments));
  }

  private void onSetUserId(MethodCall call) {
    GrowingIO.getInstance().setUserId((String)call.argument("userId"));
  }

  private void onClearUserId() {
    GrowingIO.getInstance().clearUserId();
  }

  private void onSetVisitor(MethodCall call) {
    GrowingIO.getInstance().setVisitor(toJson(call.arguments));
  }

  private void onTrack(MethodCall call) {
    String eventId = (String) call.argument("eventId");
    Double num = call.argument("num");
    boolean hasNum = call.hasArgument("num");
    GrowingIO gio = GrowingIO.getInstance();
    if (call.hasArgument("variable")) {
      JSONObject variable = toJson(call.argument("variable"));
      if (variable == null) return;
      if (hasNum) {
        gio.track(eventId, num, variable);
      } else {
        gio.track(eventId, variable);
      }
    } else {
      if (hasNum) {
        gio.track(eventId, num);
      } else {
        gio.track(eventId);
      }
    }
  }

  @SuppressWarnings("unchecked")
  private JSONObject toJson(Object obj) {
    if (obj instanceof Map) {
      return mapToJson((Map<String, Object>)obj);
    } else if (obj instanceof JSONObject) {
      return (JSONObject) obj;
    } else {
      throw new ClassCastException();
    }
  }

  private JSONObject mapToJson(Map<String, Object> map) {
    JSONObject jsonObject = new JSONObject();
    for (String key: map.keySet()) {
      try {
        if (TextUtils.isEmpty(key)) {
          LogUtil.e("GrowingIO", ErrorLog.EVENT_NAME_ILLEGAL);
          return null;
        }
        jsonObject.put(key, map.get(key));
      } catch (JSONException e) {
        e.printStackTrace();
      }
    }

    return jsonObject;
  }
}
