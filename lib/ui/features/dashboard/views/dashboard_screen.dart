import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/i18n/app_localizations.dart';
import '../../../../data/models/image_item.dart';
import '../../auth/view_models/auth_provider.dart';
import '../../../core/view_models/theme_provider.dart';
import '../../../../data/services/image_service.dart';
import '../../../../data/services/api_client.dart';
import '../../../core/theme/asumi_theme.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ImageService _imageService = ImageService();
  final ImagePicker _picker = ImagePicker();

  List<ImageItem> _images = [];
  List<({String collection, int count})> _collections = [];
  String? _activeCollection;
  bool _isLoading = true;
  bool _isUploading = false;
  String? _previewImageUrl;
  String _mediaBase = ApiClient.defaultBaseUrl;

  static const Map<String, String> _collectionLabels = {
    'asumi': '锦亚澄',
    'asumi-cg': '锦亚澄 CG',
    'sister': '妹妹',
    'sister-cg': '妹妹 CG',
    '妃爱': '妃爱',
  };

  String _collectionDisplayName(String key) {
    return _collectionLabels[key] ?? key;
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      var base = await ApiClient().getBaseUrl();
      if (base.endsWith('/')) base = base.substring(0, base.length - 1);
      if (!mounted) return;
      final auth = context.read<AuthProvider>();
      await auth.refreshProfile();
      final results = await Future.wait([
        _imageService.getImages(collection: _activeCollection),
        _imageService.getCollections(),
      ]);
      if (!mounted) return;
      setState(() {
        _mediaBase = base;
        _images = results[0] as List<ImageItem>;
        _collections = results[1] as List<({String collection, int count})>;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('加载失败: $e'), backgroundColor: AsumiTheme.rose500),
      );
    }
  }

  Future<void> _filterByCollection(String? collection) async {
    setState(() {
      _activeCollection = collection;
      _isLoading = true;
    });
    try {
      _images = await _imageService.getImages(collection: collection);
      if (!mounted) return;
      setState(() => _isLoading = false);
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  Future<void> _pickAndUpload() async {
    final file = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (file == null) return;

    setState(() => _isUploading = true);
    try {
      final len = await file.length();
      if (len > 5 * 1024 * 1024) {
        if (!mounted) return;
        setState(() => _isUploading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('图片大小不能超过 5MB'),
            backgroundColor: AsumiTheme.rose500,
          ),
        );
        return;
      }
      final newImage = await _imageService.upload(
        filePath: file.path,
        collection: _activeCollection,
      );
      if (!mounted) return;
      setState(() {
        _images.insert(0, newImage);
        _isUploading = false;
      });
      _refreshCollections();
    } catch (e) {
      if (!mounted) return;
      setState(() => _isUploading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('上传失败: $e'), backgroundColor: AsumiTheme.rose500),
      );
    }
  }

  Future<void> _refreshCollections() async {
    try {
      final collections = await _imageService.getCollections();
      if (!mounted) return;
      setState(() => _collections = collections);
    } catch (_) {}
  }

  Future<void> _updateImageCollection(ImageItem image, String? collection) async {
    try {
      final updated = await _imageService.updateCollection(image.id, collection);
      if (!mounted) return;
      setState(() {
        final idx = _images.indexWhere((i) => i.id == image.id);
        if (idx >= 0) _images[idx] = updated;
      });
      _refreshCollections();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('更新失败: $e'), backgroundColor: AsumiTheme.rose500),
      );
    }
  }

  Future<void> _deleteImage(String id) async {
    try {
      await _imageService.delete(id);
      if (!mounted) return;
      setState(() => _images.removeWhere((i) => i.id == id));
      _refreshCollections();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('删除失败: $e'), backgroundColor: AsumiTheme.rose500),
      );
    }
  }

  Future<void> _handleAvatarAction() async {
    final auth = context.read<AuthProvider>();
    final t = AppLocalizations.of(context);

    if (auth.user?.avatar != null) {
      final action = await showDialog<String>(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(t.changeAvatar),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.swap_horiz, color: AsumiTheme.rose),
                title: Text(t.changeAvatar),
                onTap: () => Navigator.of(ctx).pop('change'),
              ),
              ListTile(
                leading: const Icon(Icons.delete_outline, color: AsumiTheme.rose500),
                title: Text(t.clearAvatar),
                onTap: () => Navigator.of(ctx).pop('clear'),
              ),
            ],
          ),
        ),
      );
      if (action == null) return;
      if (action == 'clear') {
        try {
          await auth.setAvatar(null);
        } catch (_) {}
        return;
      }
    }

    // Pick and set as avatar
    final file = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (file == null) return;
    try {
      final len = await file.length();
      if (len > 5 * 1024 * 1024) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('图片大小不能超过 5MB'),
            backgroundColor: AsumiTheme.rose500,
          ),
        );
        return;
      }
      final newImage = await _imageService.upload(filePath: file.path);
      await auth.setAvatar(newImage.id);
      if (!mounted) return;
      setState(() => _images.insert(0, newImage));
      _refreshCollections();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('头像设置失败'), backgroundColor: AsumiTheme.rose500),
      );
    }
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    final t = AppLocalizations.of(context);
    if (hour >= 5 && hour < 9) return t.greetingMorning;
    if (hour >= 9 && hour < 13) return t.greetingNoon;
    if (hour >= 13 && hour < 17) return t.greetingAfternoon;
    if (hour >= 17 && hour < 22) return t.greetingEvening;
    return t.greetingNight;
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final auth = context.watch<AuthProvider>();
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = themeProvider.isDark;

    return Stack(
      children: [
        Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [const Color(0xFF0F0724), const Color(0xFF1E0A3C), const Color(0xFF2D1B2E)]
                : [AsumiTheme.cream, AsumiTheme.ivory, const Color(0xFFF0EAE6)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              _buildHeader(context, t, auth, themeProvider, isDark),
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : RefreshIndicator(
                        onRefresh: _loadData,
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            return Center(
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth: constraints.maxWidth > 800 ? 800 : double.infinity,
                                ),
                                child: ListView(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          children: [
                            const SizedBox(height: 16),
                            _buildHero(t, auth, isDark),
                            const SizedBox(height: 20),
                            _buildCollectionBar(t),
                            const SizedBox(height: 20),
                            _buildGalleryHeader(t),
                            const SizedBox(height: 12),
                            _buildImageGrid(t, isDark),
                            const SizedBox(height: 24),
                            _buildFooter(auth, isDark),
                            const SizedBox(height: 32),
                          ],
                        ),
                              ),
                            );
                          },
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
      // Image preview overlay
      floatingActionButton: _previewImageUrl != null
          ? null
          : _isUploading
              ? FloatingActionButton.extended(
                  onPressed: null,
                  backgroundColor: AsumiTheme.rose.withValues(alpha: 0.7),
                  label: Text(t.uploading),
                  icon: const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  ),
                )
              : FloatingActionButton(
                  onPressed: _pickAndUpload,
                  backgroundColor: AsumiTheme.rose,
                  child: const Icon(Icons.add, color: Colors.white),
                ),
        ),
        if (_previewImageUrl != null) _buildImagePreviewLayer(),
      ],
    );
  }

  Widget _buildImagePreviewLayer() {
    final path = _previewImageUrl!;
    return Positioned.fill(
      child: Material(
        color: Colors.black.withValues(alpha: 0.9),
        child: Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => setState(() => _previewImageUrl = null),
              ),
            ),
            Center(
              child: InteractiveViewer(
                minScale: 0.5,
                maxScale: 4,
                child: CachedNetworkImage(
                  imageUrl: _resolveImageUrl(path),
                  fit: BoxFit.contain,
                  placeholder: (_, __) => const SizedBox(
                    width: 48,
                    height: 48,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white54),
                  ),
                  errorWidget: (_, __, ___) => const Icon(Icons.broken_image, color: Colors.white54, size: 48),
                ),
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => setState(() => _previewImageUrl = null),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _resolveImageUrl(String path) {
    if (path.startsWith('http://') || path.startsWith('https://')) return path;
    final b = _mediaBase.endsWith('/') ? _mediaBase.substring(0, _mediaBase.length - 1) : _mediaBase;
    return path.startsWith('/') ? '$b$path' : '$b/$path';
  }

  Future<void> _confirmLogout(
    BuildContext context,
    AuthProvider auth,
    AppLocalizations t,
  ) async {
    if (auth.isLoggingOut) return;
    final go = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(t.logout),
        content: Text(t.logoutConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(t.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: TextButton.styleFrom(foregroundColor: AsumiTheme.rose500),
            child: Text(t.confirm),
          ),
        ],
      ),
    );
    if (go != true || !context.mounted) return;
    await auth.logout();
  }

  Widget _buildHeader(
    BuildContext context,
    AppLocalizations t,
    AuthProvider auth,
    ThemeProvider themeProvider,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: (isDark ? const Color(0xFF1E0A3C) : Colors.white).withValues(alpha: 0.5),
        border: Border(
          bottom: BorderSide(
            color: (isDark ? AsumiTheme.lavender : AsumiTheme.roseLight).withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(shape: BoxShape.circle, color: AsumiTheme.rose),
            child: const Center(
              child: Text(
                '錦',
                style: TextStyle(
                  fontFamily: AsumiTheme.displayFont,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            t.dashboardTitle,
            style: TextStyle(
              fontFamily: AsumiTheme.displayFont,
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: isDark ? const Color(0xFFF3E8FF) : AsumiTheme.plum,
            ),
          ),
          const Spacer(),
          // Theme toggle
          GestureDetector(
            onTap: () => themeProvider.toggle(),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: (isDark ? Colors.white : AsumiTheme.rose).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                isDark ? Icons.dark_mode : Icons.light_mode,
                size: 18,
                color: isDark ? AsumiTheme.roseLight : AsumiTheme.rose,
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Logout
          GestureDetector(
            onTap: auth.isLoggingOut ? null : () => _confirmLogout(context, auth, t),
            child: Opacity(
              opacity: auth.isLoggingOut ? 0.55 : 1,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AsumiTheme.rose.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    if (auth.isLoggingOut)
                      const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AsumiTheme.rose,
                        ),
                      )
                    else
                      const Icon(Icons.logout, size: 16, color: AsumiTheme.rose),
                    const SizedBox(width: 6),
                    Text(
                      auth.isLoggingOut ? t.commonLoading : t.logout,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AsumiTheme.rose,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHero(AppLocalizations t, AuthProvider auth, bool isDark) {
    final user = auth.user;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AsumiTheme.rose.withValues(alpha: 0.15),
            AsumiTheme.lavender.withValues(alpha: 0.08),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AsumiTheme.rose.withValues(alpha: 0.15),
        ),
      ),
      child: Row(
        children: [
          // Avatar
          GestureDetector(
            onTap: _handleAvatarAction,
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AsumiTheme.rose.withValues(alpha: 0.2),
                image: user?.avatar != null
                    ? DecorationImage(
                        image: CachedNetworkImageProvider(
                          _resolveImageUrl(user!.avatar!),
                        ),
                        fit: BoxFit.cover,
                      )
                    : null,
                border: Border.all(color: AsumiTheme.roseLight, width: 2),
              ),
              child: user?.avatar == null
                  ? Center(
                      child: Text(
                        (user?.username.isNotEmpty == true ? user!.username[0].toUpperCase() : '?'),
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: AsumiTheme.rose,
                          fontFamily: AsumiTheme.displayFont,
                        ),
                      ),
                    )
                  : null,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getGreeting(),
                  style: TextStyle(
                    fontSize: 14,
                    color: AsumiTheme.rose,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user?.username ?? 'User',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: isDark ? const Color(0xFFF3E8FF) : AsumiTheme.plum,
                    fontFamily: AsumiTheme.displayFont,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCollectionBar(AppLocalizations t) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 42,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              // "All" tab
              _CollectionTab(
                label: t.all,
                active: _activeCollection == null,
                onTap: () => _filterByCollection(null),
              ),
              ..._collections.map((c) => _CollectionTab(
                    label: _collectionDisplayName(c.collection),
                    active: _activeCollection == c.collection,
                    onTap: () => _filterByCollection(c.collection),
                  )),
              // Add collection button
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: GestureDetector(
                  onTap: () => _showCreateCollectionDialog(t),
                  child: Container(
                    width: 42,
                    decoration: BoxDecoration(
                      color: AsumiTheme.rose.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(21),
                      border: Border.all(
                        color: AsumiTheme.rose.withValues(alpha: 0.3),
                      ),
                    ),
                    child: const Icon(Icons.add, color: AsumiTheme.rose, size: 20),
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _showCreateCollectionDialog(AppLocalizations t) async {
    final controller = TextEditingController();
    final name = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(t.createCollection),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(
            hintText: t.collectionName,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(t.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(controller.text.trim()),
            child: Text(t.create),
          ),
        ],
      ),
    );
    if (name != null && name.isNotEmpty) {
      // Collection is created implicitly when assigning an image to it
      // Just switch to the new collection view
      setState(() => _activeCollection = name);
      _filterByCollection(name);
    }
  }

  Widget _buildGalleryHeader(AppLocalizations t) {
    final activeLabel = _activeCollection != null
        ? _collectionDisplayName(_activeCollection!)
        : t.gallery;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          activeLabel,
          style: const TextStyle(
            fontFamily: AsumiTheme.displayFont,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          '${_images.length}',
          style: TextStyle(
            color: AsumiTheme.lavender,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildImageGrid(AppLocalizations t, bool isDark) {
    if (_images.isEmpty) {
      return Container(
        height: 200,
        decoration: BoxDecoration(
          color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.03),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.image_outlined, size: 48, color: AsumiTheme.lavender.withValues(alpha: 0.5)),
              const SizedBox(height: 8),
              Text('暂无图片', style: TextStyle(color: AsumiTheme.lavender)),
            ],
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1,
          ),
          itemCount: _images.length,
          itemBuilder: (context, index) =>
              _buildImageCard(_images[index], t, isDark),
        );
      },
    );
  }

  Widget _buildImageCard(ImageItem image, AppLocalizations t, bool isDark) {
    return GestureDetector(
      onTap: () => setState(() => _previewImageUrl = image.url),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: (isDark ? AsumiTheme.lavender : AsumiTheme.roseLight).withValues(alpha: 0.2),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            // Image
            Expanded(
              child: CachedNetworkImage(
                imageUrl: _resolveImageUrl(image.url),
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(
                  color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.05),
                  child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                ),
                errorWidget: (_, __, ___) => Container(
                  color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.05),
                  child: const Icon(Icons.broken_image, color: AsumiTheme.lavender),
                ),
              ),
            ),
            // Actions bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              color: (isDark ? const Color(0xFF1E0A3C) : Colors.white).withValues(alpha: 0.8),
              child: Row(
                children: [
                  // Collection badge
                  GestureDetector(
                    onTap: () => _showCollectionPicker(image, t),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AsumiTheme.rose.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        image.collection != null
                            ? _collectionDisplayName(image.collection!)
                            : t.noCategory,
                        style: const TextStyle(fontSize: 10, color: AsumiTheme.rose),
                      ),
                    ),
                  ),
                  const Spacer(),
                  // Set as avatar
                  GestureDetector(
                    onTap: () async {
                      try {
                        await context.read<AuthProvider>().setAvatar(image.id);
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(t.setAsAvatar), backgroundColor: AsumiTheme.emerald400),
                          );
                        }
                      } catch (_) {}
                    },
                    child: const Icon(Icons.star_border, size: 16, color: AsumiTheme.gold),
                  ),
                  const SizedBox(width: 8),
                  // Delete
                  if (!image.isDefault)
                    GestureDetector(
                      onTap: () => _showDeleteConfirm(image, t),
                      child: const Icon(Icons.close, size: 16, color: AsumiTheme.rose500),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showCollectionPicker(ImageItem image, AppLocalizations t) async {
    final picked = await showDialog<String?>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('选择收藏栏'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: [
              ListTile(
                title: Text(t.noCategory),
                leading: const Icon(Icons.label_off, color: AsumiTheme.lavender),
                onTap: () => Navigator.of(ctx).pop(''),
              ),
              ..._collections.map((c) => ListTile(
                    title: Text(_collectionDisplayName(c.collection)),
                    leading: const Icon(Icons.label, color: AsumiTheme.rose),
                    selected: image.collection == c.collection,
                    onTap: () => Navigator.of(ctx).pop(c.collection),
                  )),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(t.cancel),
          ),
        ],
      ),
    );
    if (!mounted || picked == null) return;
    await _updateImageCollection(image, picked.isEmpty ? null : picked);
  }

  Future<void> _showDeleteConfirm(ImageItem image, AppLocalizations t) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(t.deleteConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(t.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: AsumiTheme.rose500),
            child: Text(t.delete),
          ),
        ],
      ),
    );
    if (confirm == true) {
      _deleteImage(image.id);
    }
  }

  Widget _buildFooter(AuthProvider auth, bool isDark) {
    final user = auth.user;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: (isDark ? AsumiTheme.lavender : AsumiTheme.roseLight).withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Column(
        children: [
          Text(
            '${user?.username ?? ''} · ${user?.email ?? ''}',
            style: TextStyle(
              fontSize: 13,
              color: AsumiTheme.lavender,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            '锦亚澄小天使世界第一 ✦',
            style: TextStyle(
              fontSize: 12,
              color: AsumiTheme.rose,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

}

class _CollectionTab extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _CollectionTab({
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 6),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: active ? AsumiTheme.rose.withValues(alpha: 0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: active ? AsumiTheme.rose : AsumiTheme.lavender.withValues(alpha: 0.25),
            width: active ? 1.5 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: active ? FontWeight.w600 : FontWeight.normal,
            color: active ? AsumiTheme.rose : null,
          ),
        ),
      ),
    );
  }
}
