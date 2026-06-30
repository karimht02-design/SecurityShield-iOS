# 🛡️ SecurityShield - دليل التطوير

## البدء السريع

### المتطلبات:
- Xcode 13 أو أحدث
- iOS 14.0+
- Swift 5.5+
- macOS 11+

### الخطوات:

1. **استنساخ المستودع:**
```bash
git clone https://github.com/karimht02-design/SecurityShield-iOS.git
cd SecurityShield-iOS
```

2. **فتح المشروع:**
```bash
open SecurityShield.xcodeproj
```

3. **تشغيل التطبيق:**
- اختر محاكي iOS من القائمة
- اضغط ▶️ Run (Cmd+R)

## هيكل المشروع

```
SecurityShield-iOS/
├── App/
│   ├── SecurityShieldApp.swift      # نقطة الدخول الرئيسية
│   └── AppDelegate.swift             # معالج التطبيق
├── Models/
│   └── ThreatModel.swift             # نماذج البيانات
├── Views/
│   ├── ContentView.swift             # الملاح الرئيسي
│   ├── DashboardView.swift           # لوحة التحكم
│   ├── ThreatDetectionView.swift     # كشف التهديدات
│   ├── VPNView.swift                 # إدارة VPN
│   └── SettingsView.swift            # الإعدادات
├── Services/
│   ├── SecurityService.swift         # خدمة الأمان الرئيسية
│   ├── ThreatDetector.swift          # كاشف التهديدات
│   └── NetworkMonitor.swift          # مراقب الشبكة
└── Resources/
    ├── Assets.xcassets               # الصور والأيقونات
    └── Localizable.strings           # النصوص المترجمة
```

## الميزات الرئيسية

### 1. 🛡️ لوحة التحكم
- عرض حالة الأمان الكاملة
- إحصائيات التهديدات اليومية
- آخر التهديدات المكتشفة
- مؤشرات الحماية الفورية

### 2. 🔍 كشف التهديدات
- فحص شامل للجهاز
- كشف تطبيقات مريبة
- مراقبة الاتصالات الشبكية
- حجب العناوين الضارة

### 3. 🔒 VPN والحماية
- تغيير الموقع تلقائياً
- اختيار من دول متعددة
- تشفير AES-256
- إخفاء عنوان IP

### 4. ⚙️ الإعدادات المتقدمة
- تفعيل/تعطيل الحماية
- إدارة التنبيهات
- فحص تلقائي منتظم
- نسخ احتياطي آمن

## الأمان

هذا التطبيق يستخدم:

- ✅ **Local Authentication** - للمصادقة البيومترية
- ✅ **Keychain** - لتخزين البيانات الحساسة
- ✅ **Network Framework** - لمراقبة الاتصالات
- ✅ **FileManager** - لكشف الجيلبريك

## التطوير

### إضافة ميزة جديدة:

1. **إنشاء فرع:**
```bash
git checkout -b feature/new-feature
```

2. **كتابة الكود والاختبار**

3. **عمل Commit:**
```bash
git commit -m "Add: وصف الميزة"
```

4. **رفع للمستودع:**
```bash
git push origin feature/new-feature
```

5. **فتح Pull Request**

## الاختبار

لاختبار الميزات:

1. **فتح Simulator**
2. **تشغيل التطبيق**
3. **اختبار كل وظيفة**

## حل المشاكل

### المشكلة: التطبيق لا يعمل
**الحل:**
- تأكد من استخدام iOS 14+
- حاول تنظيف البناء: Cmd+Shift+K
- أعد فتح Xcode

### المشكلة: الإشعارات لا تظهر
**الحل:**
- تحقق من أذونات التطبيق في Settings
- تأكد من تفعيل الإشعارات

## المساهمة

نرحب بالمساهمات! يرجى:
1. Fork المشروع
2. إنشاء فرع للميزة
3. Commit التغييرات
4. Push الفرع
5. فتح Pull Request

## الترخيص

MIT License - انظر LICENSE

## الدعم

للمساعدة:
- 📧 البريد: support@securityshield.app
- 🐛 اختبار الأخطاء: https://github.com/karimht02-design/SecurityShield-iOS/issues
- 💬 النقاشات: https://github.com/karimht02-design/SecurityShield-iOS/discussions

---

**شكراً لاستخدام SecurityShield! 🛡️✨**
