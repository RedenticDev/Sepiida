#import "SPDVexillarius.h"

const struct VXXPCKey VXKey = {
    .timeout = "timeout",
    .identifier = "identifier",
    .type = "type",
    .icon = "icon",
    .title = "title",
    .subtitle = "subtitle",
    .leadingImageName = "leadingImageName",
    .leadingImagePath = "leadingImagePath",
    .trailingImageName = "trailingImageName",
    .trailingImagePath = "trailingImagePath",
    .trailingText = "trailingText",
    .backgroundColor = "backgroundColor"
};

xpc_object_t vexillariusMessage(const char *title, const char *subtitle, const char *imageName, double timeShown) {
    xpc_object_t message = xpc_dictionary_create(NULL, NULL, 0);
    xpc_dictionary_set_double(message, VXKey.timeout, timeShown ?: 2.0);
    xpc_dictionary_set_string(message, VXKey.title, title);
    xpc_dictionary_set_string(message, VXKey.subtitle, subtitle);

    NSString *mode = [UITraitCollection currentTraitCollection].userInterfaceStyle == UIUserInterfaceStyleLight ? @"Light" : @"Dark";
    const char *imagePath = [[NSString stringWithFormat:@"%@/%s-%@.png", TWEAK_PREFS_BUNDLE, imageName, mode] UTF8String];
    xpc_dictionary_set_string(message, VXKey.leadingImagePath, imagePath);

    return message;
}

void sendVexillariusMessage(xpc_object_t message) {
    static xpc_connection_t connection;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        connection = xpc_connection_create_mach_service("com.udevs.vexillarius", NULL, 0);
        xpc_connection_set_event_handler(connection, ^(xpc_object_t event) {});
        xpc_connection_activate(connection);
        NSLog(@"Connection Initialized (onceToken = %ld)", onceToken);
    });
    if (connection) {
        if (onceToken == -1) {
            xpc_connection_resume(connection);
        }
        xpc_connection_send_message(connection, message);
        NSLog(@"Message sent");
        xpc_connection_suspend(connection);
    }
}

void showBanner(const char *title) {
    if (@available(iOS 14.0, *)) {
        sendVexillariusMessage(vexillariusMessage(title, [TWEAK_NAME UTF8String], "IconTemplate", 2.0));
    }
}
