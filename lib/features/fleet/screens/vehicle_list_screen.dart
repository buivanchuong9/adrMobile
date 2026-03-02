import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/video_api_service.dart';
import '../../../core/models/video_job.dart';

class VehicleListScreen extends StatefulWidget {
  const VehicleListScreen({super.key});

  @override
  State<VehicleListScreen> createState() => _VehicleListScreenState();
}

class _VehicleListScreenState extends State<VehicleListScreen> {
  final VideoApiService _apiService = VideoApiService();
  List<VideoJob> _videos = [];
  bool _isLoading = false;
  String _searchQuery = '';
  bool _isGridView = false;

  @override
  void initState() {
    super.initState();
    _loadVideos();
  }

  Future<void> _loadVideos() async {
    setState(() => _isLoading = true);
    try {
      final videos = await _apiService.listVideos();
      setState(() {
        _videos = videos.map((v) => VideoJob.fromJson(v)).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi tải dữ liệu: $e')),
        );
      }
    }
  }

  List<VideoJob> get _filteredVideos {
    if (_searchQuery.isEmpty) return _videos;
    return _videos.where((video) {
      final query = _searchQuery.toLowerCase();
      final filename = video.filename?.toLowerCase() ?? '';
      final jobId = video.jobId.toLowerCase();
      return filename.contains(query) || jobId.contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundSubtle,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 180,
            floating: false,
            pinned: true,
            backgroundColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF2563EB),
                      Color(0xFF3B82F6),
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 48, 20, 16),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(
                            Icons.video_library,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Video Library',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Analyzed Videos',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() => _isGridView = !_isGridView);
                          },
                          icon: Icon(
                            _isGridView ? Icons.list : Icons.grid_view,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.refresh_rounded, color: Colors.white),
                          onPressed: _loadVideos,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                onChanged: (value) => setState(() => _searchQuery = value),
                decoration: InputDecoration(
                  hintText: 'Search videos...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () => setState(() => _searchQuery = ''),
                        )
                      : null,
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: AppColors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 2),
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: _isLoading
                ? const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  )
                : _filteredVideos.isEmpty
                    ? SliverFillRemaining(
                        child: _EmptyLibraryState(searchQuery: _searchQuery),
                      )
                    : _isGridView
                        ? SliverGrid(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.85,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                            ),
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final video = _filteredVideos[index];
                                return VideoGridCard(
                                  video: video,
                                  onTap: () => _showVideoDetails(video),
                                );
                              },
                              childCount: _filteredVideos.length,
                            ),
                          )
                        : SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final video = _filteredVideos[index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: VideoCard(
                                    video: video,
                                    onTap: () => _showVideoDetails(video),
                                  ),
                                );
                              },
                              childCount: _filteredVideos.length,
                            ),
                          ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }

  void _showVideoDetails(VideoJob video) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => VideoDetailsSheet(video: video),
    );
  }
}

class VideoCard extends StatelessWidget {
  final VideoJob video;
  final VoidCallback onTap;

  const VideoCard({
    super.key,
    required this.video,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color statusColor = _getStatusColor(video.status);
    final IconData statusIcon = _getStatusIcon(video.status);
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                // Thumbnail/Icon
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [statusColor, statusColor.withOpacity(0.7)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: statusColor.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.play_circle_outline,
                    color: Colors.white,
                    size: 36,
                  ),
                ),
                const SizedBox(width: 16),
                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        video.filename ?? 'Video ${video.jobId.substring(0, 8)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.access_time, size: 14, color: AppColors.textTertiary),
                          const SizedBox(width: 4),
                          Text(
                            _formatDate(video.createdAt),
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'ID: ${video.jobId.substring(0, 12)}...',
                        style: const TextStyle(
                          color: AppColors.textTertiary,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // Status badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: statusColor.withOpacity(0.3)),
                  ),
                  child: Column(
                    children: [
                      Icon(statusIcon, size: 20, color: statusColor),
                      const SizedBox(height: 4),
                      Text(
                        _getStatusText(video.status),
                        style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (video.status == 'processing' && video.progress > 0) ...[
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Processing',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '${video.progress}%',
                        style: TextStyle(
                          fontSize: 12,
                          color: statusColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: video.progress / 100,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                      minHeight: 8,
                    ),
                  ),
                ],
              ),
            ],
            if (video.events != null && video.events!.isNotEmpty) ...[
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Divider(height: 1),
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.warning_amber_rounded,
                      size: 18,
                      color: AppColors.warning,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${video.events!.length} Events Detected',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Tap to view details',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right,
                    color: AppColors.textTertiary,
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
      case 'done':
        return AppColors.success;
      case 'processing':
      case 'uploading':
        return AppColors.premiumOrange;
      case 'failed':
      case 'error':
        return AppColors.error;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
      case 'done':
        return Icons.check_circle;
      case 'processing':
      case 'uploading':
        return Icons.sync;
      case 'failed':
      case 'error':
        return Icons.error;
      default:
        return Icons.help;
    }
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
      case 'done':
        return 'Hoàn tất';
      case 'processing':
        return 'Đang xử lý';
      case 'uploading':
        return 'Đang tải';
      case 'failed':
      case 'error':
        return 'Lỗi';
      default:
        return status;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    
    if (diff.inMinutes < 1) return 'Vừa xong';
    if (diff.inMinutes < 60) return '${diff.inMinutes} phút trước';
    if (diff.inHours < 24) return '${diff.inHours} giờ trước';
    if (diff.inDays < 7) return '${diff.inDays} ngày trước';
    
    return '${date.day}/${date.month}/${date.year}';
  }
}

class VideoDetailsSheet extends StatelessWidget {
  final VideoJob video;

  const VideoDetailsSheet({super.key, required this.video});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            video.filename ?? 'Video Details',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Job ID: ${video.jobId}',
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 24),
          _buildInfoRow(
            icon: Icons.info_outline,
            label: 'Trạng thái',
            value: _getStatusText(video.status),
            valueColor: _getStatusColor(video.status),
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            icon: Icons.access_time,
            label: 'Thời gian tạo',
            value: '${video.createdAt.day}/${video.createdAt.month}/${video.createdAt.year} ${video.createdAt.hour}:${video.createdAt.minute.toString().padLeft(2, '0')}',
          ),
          if (video.events != null && video.events!.isNotEmpty) ...[
            const SizedBox(height: 12),
            _buildInfoRow(
              icon: Icons.warning_amber_rounded,
              label: 'Sự kiện',
              value: '${video.events!.length} phát hiện',
              valueColor: AppColors.warning,
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            const Text(
              'Các sự kiện phát hiện:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),
            ...video.events!.take(5).map((event) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Icon(
                    Icons.circle,
                    size: 8,
                    color: _getSeverityColor(event.severity),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      event.displayName,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                  Text(
                    event.timestamp,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            )),
          ],
          const SizedBox(height: 24),
          if (video.videoUrl != null)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Open video player
                },
                icon: const Icon(Icons.play_arrow),
                label: const Text('Xem Video'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.premiumOrange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.textSecondary),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: valueColor ?? AppColors.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
      case 'done':
        return AppColors.success;
      case 'processing':
      case 'uploading':
        return AppColors.premiumOrange;
      case 'failed':
      case 'error':
        return AppColors.error;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
      case 'done':
        return 'Hoàn tất';
      case 'processing':
        return 'Đang xử lý';
      case 'uploading':
        return 'Đang tải';
      case 'failed':
      case 'error':
        return 'Lỗi';
      default:
        return status;
    }
  }

  Color _getSeverityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'high':
        return AppColors.error;
      case 'medium':
        return AppColors.warning;
      default:
        return AppColors.success;
    }
  }
}

class _EmptyLibraryState extends StatelessWidget {
  final String searchQuery;

  const _EmptyLibraryState({required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: const Color(0xFF3B82F6).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              searchQuery.isEmpty ? Icons.video_library_outlined : Icons.search_off,
              size: 80,
              color: const Color(0xFF3B82F6).withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            searchQuery.isEmpty ? 'No Videos Yet' : 'No Results Found',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            searchQuery.isEmpty
                ? 'Analyzed videos will appear here'
                : 'Try a different search term',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}

class VideoGridCard extends StatelessWidget {
  final VideoJob video;
  final VoidCallback onTap;

  const VideoGridCard({
    super.key,
    required this.video,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color statusColor = _getStatusColor(video.status);
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail area
            Container(
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    statusColor.withOpacity(0.7),
                    statusColor,
                  ],
                ),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Icon(
                      Icons.play_circle_outline,
                      size: 48,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(_getStatusIcon(video.status), size: 12, color: statusColor),
                          const SizedBox(width: 4),
                          Text(
                            _getStatusText(video.status),
                            style: TextStyle(
                              color: statusColor,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Info area
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      video.filename ?? 'Video ${video.jobId.substring(0, 8)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    if (video.events != null && video.events!.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.warning.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '${video.events!.length} events',
                          style: const TextStyle(
                            color: AppColors.warning,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    else
                      Text(
                        _formatDate(video.createdAt),
                        style: const TextStyle(
                          color: AppColors.textTertiary,
                          fontSize: 11,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
      case 'done':
        return AppColors.success;
      case 'processing':
      case 'uploading':
        return AppColors.premiumOrange;
      case 'failed':
      case 'error':
        return AppColors.error;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
      case 'done':
        return Icons.check_circle;
      case 'processing':
      case 'uploading':
        return Icons.sync;
      case 'failed':
      case 'error':
        return Icons.error;
      default:
        return Icons.help;
    }
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
      case 'done':
        return 'Done';
      case 'processing':
        return 'Processing';
      case 'uploading':
        return 'Uploading';
      case 'failed':
      case 'error':
        return 'Error';
      default:
        return status;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    
    return '${date.day}/${date.month}/${date.year}';
  }
}

