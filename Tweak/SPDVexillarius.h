#import <xpc/xpc.h>
#import <UIKit/UIKit.h>

#define VEXILLARIUS_INSTALLED [[NSFileManager defaultManager] fileExistsAtPath:@"/usr/libexec/vexillarius"]

#ifdef __cplusplus
extern "C" {
#endif

    extern const struct VXXPCKey {
        const char *timeout;
        const char *identifier;
        const char *type;
        const char *icon;
        const char *title;
        const char *subtitle;
        const char *leadingImageName;
        const char *leadingImagePath;
        const char *trailingImageName;
        const char *trailingImagePath;
        const char *trailingText;
        const char *backgroundColor;
    } VXKey;

    xpc_object_t vexillariusMessage(const char *title, const char *subtitle, const char *imageName, double timeout);
    void sendVexillariusMessage(xpc_object_t message);
    void showBanner(const char *title);

#ifdef __cplusplus
}
#endif
