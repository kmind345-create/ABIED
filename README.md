# Specialist Nurse — Flutter Web Portfolio

بورتفوليو احترافي كـ Flutter Web App لـ Specialist Nurse، الألوان مستخرجة فعليًا من صورتك (البدلة الكحلي، مبنى المستشفى الرملي، السماء، الشجر) + صورتك الشخصية في الـ Hero + أنيميشن 3D حقيقي (مش CSS وهمي).

## إيه اللي جوه؟
- **Hero**: صورتك في دايرة بتميل مع حركة الماوس (3D tilt حقيقي بـ Matrix4 perspective)، مع اسمك والعنوان بحركة دخول متتابعة (staggered).
- **Vitals bar**: أرقام (سنوات خبرة، عدد المرضى...) بخط Monospace شكله زي شاشة المونيتور.
- **ECG line**: خط قلب متحرك (الـ signature element) بيتكرر كديفايدر بين الأقسام — العنصر ده هو اللي هيفتكر بيه حد شاف الصفحة.
- **Skills**: كروت بتميل 3D لما تعمل hover عليها.
- **Experience**: تايم لاين حقيقي بترتيب زمني.
- **Certifications**: كروت شهادات بتـ *flip* بزاوية 3D حقيقية لما تدوس عليها (زي الـ ID badge بتاع الممرض).
- **Contact**: أزرار قابلة للضغط (mail / phone / linkedin).

كل التصميم متجاوب (responsive) على الموبايل والديسكتوب.

## عدّل بياناتك (مكان واحد بس)
افتح `lib/data/portfolio_data.dart` وغيّر: الاسم، المسمى الوظيفي، النبذة، المهارات، الخبرات، الشهادات، وبيانات التواصل. الصفحة كلها بتقرا من الملف ده تلقائيًا.

## تشغيل المشروع محليًا
لازم يكون عندك Flutter SDK متثبت (https://docs.flutter.dev/get-started/install).

```bash
cd nurse_portfolio
flutter pub get
flutter run -d chrome
```

## بناء نسخة نهائية للنشر (deploy)
```bash
flutter build web --release
```
الملفات النهائية هتلاقيها في `build/web/` — ارفعها على أي استضافة ثابتة (Firebase Hosting, GitHub Pages, Netlify, Vercel...).

## استبدال الصورة
الصورة موجودة في `assets/images/profile.png`. لو عايز تستبدلها بصورة تانية، خليها بنفس الاسم أو غيّري المسار في `lib/widgets/hero_section.dart` (بحث عن `AssetImage`).
