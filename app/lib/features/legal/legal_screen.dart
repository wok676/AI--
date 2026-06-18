import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_dimens.dart';

/// In-app legal document screens (UI §4.1: Auth ─links─> Terms / Privacy).
///
/// 应用内《用户协议》《隐私政策》页面。做成应用内可滚动长文页面,**不依赖尚未部署
/// 的公网 URL**;双端审核硬性要求这两份文档必须能打开(否则被拒)。
///
/// 设计约束(对齐 docs/UI-DESIGN.md):
/// - 可滚动长文 + 顶部 AppBar 自带返回(RTL 下返回箭头自动镜像);
/// - 安全区适配(Scaffold + SafeArea);
/// - 方向无关内边距(`EdgeInsetsDirectional`),ar/ur 整体镜像友好;
/// - 全部文案走 i18n key(零硬编码裸字符串),遵循现有 Material 3 主题(仅浅色)。
///
/// !!! 法律文案为临时占位 !!!
/// 顶部横幅明确标注:最终法律文案待 PM / ASO 提供,正式公网 URL 待部署后接入。
/// 当前 en/zh 为写实的实质性临时正文,其余 10 语言沿用「英文占位 + TRANSLATION_PENDING」。

/// 一份法律文档的章节:小标题 + 正文段落。
class _LegalSection {
  const _LegalSection({required this.heading, required this.body});

  final String heading;
  final String body;
}

/// 通用法律文档页面骨架:标题 + 顶部「草稿声明」横幅 + 章节列表。
class _LegalDocScreen extends StatelessWidget {
  const _LegalDocScreen({
    required this.title,
    required this.lastUpdated,
    required this.sections,
  });

  final String title;
  final String lastUpdated;
  final List<_LegalSection> sections;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);

    return Scaffold(
      // AppBar 自带返回按钮;RTL 下 Flutter 自动镜像返回箭头与方向。
      appBar: AppBar(title: Text(title)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsetsDirectional.fromSTEB(
            AppSpacing.md,
            AppSpacing.md,
            AppSpacing.md,
            AppSpacing.xxl,
          ),
          children: <Widget>[
            // —— 草稿/占位声明横幅(诚实标注,不谎称终稿)——
            _DraftNotice(text: l10n.legal_draftNotice),
            const SizedBox(height: AppSpacing.md),
            // —— 最后更新时间(占位)——
            Text(
              lastUpdated,
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            // —— 章节正文 ——
            for (final _LegalSection section in sections) ...<Widget>[
              Text(section.heading, style: theme.textTheme.titleMedium),
              const SizedBox(height: AppSpacing.xs),
              Text(
                section.body,
                style: theme.textTheme.bodyMedium?.copyWith(
                  height: 1.5,
                ), // 长文行高更舒适(CJK/拉丁通用)。
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ],
        ),
      ),
    );
  }
}

/// 顶部「这是占位草稿」声明条:errorContainer 底色,显著但不刺眼。
class _DraftNotice extends StatelessWidget {
  const _DraftNotice({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: theme.colorScheme.tertiaryContainer,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(
            Icons.info_outline,
            size: 18,
            color: theme.colorScheme.onTertiaryContainer,
          ),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onTertiaryContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 《用户协议》页(路由 /legal/terms)。
class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    return _LegalDocScreen(
      title: l10n.legal_terms_title,
      lastUpdated: l10n.legal_lastUpdated,
      sections: <_LegalSection>[
        _LegalSection(
          heading: l10n.legal_terms_s1_h,
          body: l10n.legal_terms_s1_b,
        ),
        _LegalSection(
          heading: l10n.legal_terms_s2_h,
          body: l10n.legal_terms_s2_b,
        ),
        _LegalSection(
          heading: l10n.legal_terms_s3_h,
          body: l10n.legal_terms_s3_b,
        ),
        _LegalSection(
          heading: l10n.legal_terms_s4_h,
          body: l10n.legal_terms_s4_b,
        ),
        _LegalSection(
          heading: l10n.legal_terms_s5_h,
          body: l10n.legal_terms_s5_b,
        ),
        _LegalSection(
          heading: l10n.legal_terms_s6_h,
          body: l10n.legal_terms_s6_b,
        ),
        _LegalSection(
          heading: l10n.legal_contact_h,
          body: l10n.legal_contact_b,
        ),
      ],
    );
  }
}

/// 《隐私政策》页(路由 /legal/privacy)。
class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    return _LegalDocScreen(
      title: l10n.legal_privacy_title,
      lastUpdated: l10n.legal_lastUpdated,
      sections: <_LegalSection>[
        _LegalSection(
          heading: l10n.legal_privacy_s1_h,
          body: l10n.legal_privacy_s1_b,
        ),
        _LegalSection(
          heading: l10n.legal_privacy_s2_h,
          body: l10n.legal_privacy_s2_b,
        ),
        _LegalSection(
          heading: l10n.legal_privacy_s3_h,
          body: l10n.legal_privacy_s3_b,
        ),
        _LegalSection(
          heading: l10n.legal_privacy_s4_h,
          body: l10n.legal_privacy_s4_b,
        ),
        _LegalSection(
          heading: l10n.legal_privacy_s5_h,
          body: l10n.legal_privacy_s5_b,
        ),
        _LegalSection(
          heading: l10n.legal_privacy_s6_h,
          body: l10n.legal_privacy_s6_b,
        ),
        _LegalSection(
          heading: l10n.legal_contact_h,
          body: l10n.legal_contact_b,
        ),
      ],
    );
  }
}
