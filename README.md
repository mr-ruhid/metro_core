August 28, 2026, 10:50:09 AM
What We Did Together So Far:
1. PROJECT IDEA - "metro_core"

Independent mobile OS (not Android/Web-based)

Linux kernel + Flutter UI + C++ backend

.mtx package format (signed apps)

2. PROJECT SETUP

Created standard Flutter project: flutter create metro_core

Pushed to GitHub: mr-ruhid/metro_core

3. STRUCTURE DECIDED

lib/ - Flutter UI (Dart)

linux/ - C++ backend (not written yet)

Using MOCK layer to test UI first

4. METHODOLOGY DECIDED

MOCK mode - Write UI now with fake data

REAL mode - Connect to C++ later

UI written ONCE, never changes

5. CURRENT STATUS

Decided to create README.md first

Next: README.md → then lib/ffi/system_ffi.dart

SUMMARY:
#	What We Did	Status
1	Project idea	✅ Done
2	Create Flutter project	✅ Done
3	Push to GitHub	✅ Done
4	Decide structure	✅ Done
5	Decide MOCK vs REAL	✅ Done
6	Write README.md	⏳ READY
7	system_ffi.dart (MOCK)	⏳ NEXT

# metro_core

**metro_core** — Android və ya Web əsaslı olmayan, tamamilə müstəqil, Linux nüvəsi üzərində qurulan mobil əməliyyat sistemidir.

## Fəlsəfə və Arxitektura

*   **Nüvə (Kernel):** Yüngül, mainline Linux (postmarketOS / Alpine əsaslı).
*   **UI və Tətbiqlər:** 100% Flutter (Dart) ilə yazılır və birbaşa ARM64 Native Machine Code kimi kompilyasiya olunur.
*   **Aparatla Əlaqə:** Flutter təbəqəsi, C++ Native Bindings və Dart FFI (Foreign Function Interface) vasitəsilə sistem servisləri ilə birbaşa əlaqə saxlayır.
*   **Ekran (Shell):** Windows Phone Metro UI və Fluent Design ilhamlı, tam inteqrasiya olunmuş monolitik Flutter mühiti.
*   **Tətbiq Formatı:** Sistem, xüsusi və kriptoqrafik imzalanmış `.mtx` (Metro Executable) fayllarını qəbul edir. `.apk` və ya `.deb` faylları dəstəklənmir. İmzasız tətbiqlər sistem səviyyəsində bloklanır.
*   **Müstəqillik:** Bu layihə Android-in (AOSP) bir klonu, fork-u və ya GSI variantı DEYİLDİR. Google-un heç bir məhsulundan və lisenziyasından asılı deyildir.

## Texniki Quruluş və Metodologiya

Layihə iki mərhələli strategiya ilə inkişaf etdirilir:

1.  **MOCK Rejim (İlkin Mərhələ):**
    *   Bütün UI (Dart) kodu, heç bir xarici asılılıq olmadan işləyə bilməsi üçün **saxta (fake) data** ilə yazılır.
    *   C++ tərəfdəki sistem servisləri hələ yazılmadığı üçün, Dart tərəfindəki `SystemFfi` sinfi müvəqqəti dəyərlər qaytarır.
    *   Bu, UI-nin heç bir xəta vermədən işləməsinə imkan verir və UI kodu bir daha dəyişdirilməyəcək şəkildə sabitlənir.

2.  **REAL Rejim (İkinci Mərhələ):**
    *   C++ tərəfdəki `.so` kitabxanaları yazıldıqdan və `linux/` qovluğuna köçürüldükdən sonra, MOCK funksiyalar real FFI çağırışları ilə əvəzlənir.
    *   Bu mərhələdə UI-da heç bir dəyişiklik edilmir; yalnız arxa plan məntiqi (backend) dəyişir.

## Qovluq Strukturu

*   `lib/` — Flutter UI (Dart) təbəqəsi.
*   `linux/` — Native C++ kitabxanaları (`.so` faylları).
*   `system/services/` — C++ servislərinin mənbə kodu (WSL/Ubuntu mühitində yaradılır).

## Hazırkı Status (Ətraflı Cədvəl)

| # | Görülən İş | Status |
|---|------------|--------|
| 1 | Layihə ideyası (metro_core) | ✅ Tamamlandı |
| 2 | Flutter layihəsinin yaradılması | ✅ Tamamlandı |
| 3 | GitHub-a yüklənməsi | ✅ Tamamlandı |
| 4 | Strukturun müəyyənləşdirilməsi | ✅ Tamamlandı |
| 5 | MOCK vs REAL metodologiyası | ✅ Tamamlandı |
| 6 | README.md faylının yazılması | ✅ Tamamlandı |
| 7 | `lib/ffi/system_ffi.dart` (MOCK) | ⏳ Sırada |


