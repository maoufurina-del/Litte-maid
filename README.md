# Custom Player Model — Maid Lite
**Fabric 1.20.1 | Ringan untuk HP RAM 2GB**

Mod companion maid seperti Touhou Little Maid, dengan dukungan ganti model format YSM (Yes Steve Model).

---

## ✨ Fitur

| Fitur | Keterangan |
|---|---|
| 🧸 Maid companion | Entity maid yang bisa dijinakkan & mengikuti player |
| 🎨 Custom model | Model maid bisa diganti via file JSON (format YSM subset) |
| 🪶 Ringan | Dirancang hemat RAM, optimal di HP 2GB seperti Oppo A3s |
| 🪑 Sit/Stand | Klik kanan maid untuk duduk/berdiri |
| 📦 Spawn Egg | Panggil maid dengan Maid Spawn Egg di tab creative |
| ⌨️ Keybind | Tekan `M` untuk pilih model player sendiri |

---

## 🎮 Cara Pakai

### 1. Panggil Maid
- Buka **Creative Inventory** → tab **Custom Player Model**
- Ambil **Maid Spawn Egg** → klik di tanah

### 2. Jinakkan Maid
- Klik kanan maid dengan **Gula** atau **Kue** (33% chance)
- Setelah dijinakkan, maid akan mengikutimu

### 3. Duduk / Berdiri
- Klik kanan maid → toggle sit/stand

### 4. Ganti Model Maid
- **Shift + Klik kanan** maid → buka layar pilih model
- Pilih model dari daftar → klik Terapkan

### 5. Ganti Model Player (Diri Sendiri)
- Tekan **M** → buka layar pilih model player

---

## 📁 Cara Tambah Model (Format YSM)

Taruh file model di:
```
.minecraft/config/customplayermodel/models/
```

Struktur file `.json`:
```json
{
  "name": "Nama Model",
  "author": "Pembuatnya",
  "texture": "nama_texture.png",
  "geometry": { ... }
}
```

Taruh texture di folder yang sama dengan file JSON.

Lihat contoh lengkap di:
`src/main/resources/assets/customplayermodel/models/sample_model_format.json`

---

## 🔧 Build Mod

**Requirement:**
- Java 17+
- Gradle 8.4 (otomatis via wrapper)
- Internet (download dependency Fabric + GeckoLib)

```bash
# Di folder minecraft-mod/
./gradlew build
```

Output JAR ada di: `build/libs/custom-player-model-1.0.0.jar`

**Install:**
1. Copy JAR ke `.minecraft/mods/`
2. Pastikan sudah ada **Fabric Loader 0.15.11+** dan **Fabric API**

---

## 🏗️ Struktur Kode

```
src/main/java/com/customplayermodel/
├── CustomPlayerModelMod.java       ← Entry point server
├── CPMNetwork.java                 ← Packet sync (player model + maid model)
├── CPMServerState.java             ← State model player di server
├── entity/
│   ├── MaidEntity.java             ← Entity companion maid (AI, NBT, interaksi)
│   ├── ModEntities.java            ← Registrasi entity type
│   └── ModItems.java               ← Spawn egg + item group
├── client/
│   ├── CustomPlayerModelClient.java ← Entry point client
│   ├── CPMClientRegistry.java       ← Daftar renderer & model layer
│   ├── model/
│   │   ├── CPMModelManager.java     ← Load & cache model (LRU max 10)
│   │   └── CPMModelData.java        ← Data model (nama, texture, geometry)
│   ├── renderer/
│   │   ├── MaidEntityRenderer.java  ← Render maid (custom/fallback)
│   │   ├── MaidEntityModel.java     ← Model default maid (animasi berjalan/duduk)
│   │   └── CPMPlayerRenderer.java   ← Render player custom model
│   ├── screen/
│   │   ├── ModelSelectorScreen.java ← GUI pilih model untuk player
│   │   └── MaidModelScreen.java     ← GUI pilih model untuk maid
│   └── mixin/
│       └── PlayerEntityRendererMixin.java ← Hook render player
```

---

## ⚡ Optimasi untuk HP RAM 2GB

- **LRU Cache**: maksimal 10 model dimuat di RAM sekaligus (otomatis buang yang lama)
- **Lazy Load**: model hanya dimuat saat pertama dibutuhkan, bukan saat startup
- **Tracked Update Rate**: maid di-sync lebih jarang (hemat CPU & bandwidth)
- **Simple AI**: hanya pakai goal bawaan Minecraft (FollowOwner, WanderAround, LookAt)
- **Cache Clear on Shutdown**: RAM dibebaskan saat keluar game
- **No Heavy Pathfinding**: tidak ada custom pathfinder yang memboroskan CPU

---

## 🗺️ Roadmap

- [x] Scaffold dasar mod Fabric 1.20.1
- [x] Entity maid (follow, sit, tame, interaksi)
- [x] Sistem load model JSON (YSM subset)
- [x] GUI pilih model (player & maid)
- [x] Network packet sync model
- [ ] Integrasi penuh GeckoLib animasi BBModel
- [ ] Support file model YSM (.ysm) langsung
- [ ] Animasi khusus (idle, walk, sit, attack)
- [ ] Inventory maid (simpan item)
- [ ] Multi-maid per player

---

## 📜 Lisensi
MIT — bebas digunakan & dimodifikasi.
