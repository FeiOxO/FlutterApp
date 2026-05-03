# Flutter Build — GitHub Actions 操作指南

> 每次 push 到 `main` 分支，CI 会自动执行代码检查 → 测试 → 构建 APK。

---

## 一、第一次使用：启用 Actions

1. 打开仓库 https://github.com/FeiOxO/FlutterApp
2. 点击顶部 **Actions** tab
3. 如果看到提示 "Workflows aren't available yet"：
   - 点击 **I understand my workflows, go ahead and enable them**
4. 推送一次代码，Actions 就会自动触发

---

## 二、查看 CI 运行状态

### 方式 A：在 GitHub 网页上

```
仓库首页 → Actions tab → 左侧选 "Flutter Build"
```

你会看到每次 push 的记录列表：
- 🟢 绿色勾 = 全部通过
- 🔴 红色叉 = 有失败
- 🟡 黄色圈 = 正在运行

### 方式 B：点击查看详情

点进任意一条记录，能看到 3 个 job：

| Job | 做什么 | 预计时间 |
|-----|--------|---------|
| 🔍 Analyze | flutter analyze 代码检查 | ~1 分钟 |
| 🧪 Test | flutter test 跑单元测试 | ~1 分钟 |
| 📦 Build APK | 构建 debug APK | ~3-5 分钟 |

点进每个 job 可以展开看详细日志。

---

## 三、下载 APK

当 **Build APK** job 变成绿色勾 ✅ 后：

1. 点进这条 CI 记录
2. 滚动到页面底部，找到 **Artifacts** 区域
3. 点击 **app-debug** 下载

⚠️ **注意**：下载的是 `artifact.zip`，里面才是 `app-debug.apk`
- 解压得到 APK 文件
- 直接传到手机上安装

---

## 四、手动触发构建（不 push 也能跑）

有时候只是调试，不想改代码，可以手动触发：

1. 仓库 → **Actions** tab
2. 左侧选 **Flutter Build**
3. 右侧点 **Run workflow** 按钮
4. 分支选 `main` → 点绿色 **Run workflow**
5. 等几分钟就能下载 APK

---

## 五、CI 的完整流程

```
你本地改代码
     │
     ▼
  git add . && git commit -m "xxx"
  git push origin main
     │
     ▼
  GitHub Actions 自动触发
     │
     ├─ 1️⃣ checkout 拉代码
     ├─ 2️⃣ Setup Flutter 3.41.9
     ├─ 3️⃣ flutter pub get（有缓存，很快）
     ├─ 4️⃣ flutter analyze（检查代码质量）
     ├─ 5️⃣ flutter test（跑单元测试）
     ├─ 6️⃣ flutter build apk --debug（构建）
     └─ 7️⃣ upload artifact（上传 APK）
     │
     ▼
  去 GitHub Actions 下载 APK
```

---

## 六、常见问题

### Q：CI 跑了很久还没结束？
第一次跑比较慢（需要下载 Flutter SDK + Gradle 依赖），后续有缓存会快很多。耐心等 3-5 分钟就好。

### Q：Analyze 失败了怎么办？
点进 Analyze job 看日志，通常是代码风格问题。本地跑一下 `flutter analyze` 就能复现。

### Q：Test 失败了？
点进 Test job 看日志，本地跑 `flutter test` 排查。

### Q：怎么下载 APK？
参考上面「下载 APK」部分。**不要**把 artifact.zip 直接当 APK 用，要解压！

### Q：这个项目是私仓，配置会暴露吗？
不会。仓库是私有的，只有你能看到。

---

## 七、CI 工作流文件位置

`.github/workflows/flutter-ci.yml`

如需修改配置（如改 Flutter 版本、加新的 job），直接编辑这个文件，push 后 CI 会自动使用新配置。
