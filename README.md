# PVT App (Psychomotor Vigilance Test)

Esta es una aplicación móvil desarrollada en Flutter que implementa el **Psychomotor Vigilance Test (PVT)**, una herramienta utilizada para medir el estado de alerta, el tiempo de reacción y la fatiga.

## 📱 Plataformas

- Android
- iOS

## 🧠 ¿Qué hace la app?

- Muestra un estímulo visual aleatorio (contadores).
- Mide el tiempo de reacción del usuario.
- Detecta lapsos (respuestas lentas) y respuestas anticipadas.
- Guarda los resultados localmente con SQLite.
- Permite visualizar sesiones anteriores y exportar resultados.

## 📦 Tecnologías utilizadas

- Flutter 3.19+
- SQLite (usando `sqflite`)
- `provider` para el manejo de estado
- UI moderna y sobria, adaptada al sistema (light/dark mode)

## ▶️ Cómo ejecutar

1. Clonar el repositorio:
   ```bash
   git clone git@github.com:mrhodev/PVTest.git
   cd PVTest
   ```

2. Obtener dependencias:
   ```bash
   flutter pub get
   ```

3. Ejecutar:
   ```bash
   flutter run
   ```

> Si usás macOS para desarrollo iOS, asegurate de tener instalado CocoaPods (`sudo gem install cocoapods`) y correr `pod install` en `ios/`.

## 📁 Estructura

- `main.dart`: Punto de entrada.
- `screens/`: Pantallas principales (home, test, resultados).
- `db/`: Helper para base de datos SQLite.
- `models/`: Clases de datos (evento, sesión).
- `widgets/`: Componentes visuales reutilizables.

## ⚠️ Nota

Este MVP es ideal como base para estudios de sueño, neurociencia cognitiva, pilotos o cualquier situación donde la vigilancia sea crítica.

---

Desarrollado por [mrhodev](https://github.com/mrhodev).