import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../common/widgets/app_gradient_background.dart';
import '../../common/widgets/app_snackbar.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/locale_controller.dart';
import '../../router/app_router.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_dimens.dart';
import 'auth_controller.dart';

/// 当前同意政策版本(与 API 注册请求 consentVersion 对齐)。
const String _kConsentVersion = '1.0';

/// 登录 / 注册页(UI §5.1 / PRD §4.1)。
/// - 邮箱密码;注册含**默认未勾选**的知情同意(未勾按钮置灰、热区≥48dp);
/// - iOS 显示 Sign in with Apple 官方按钮;
/// - 错误全走 messageKey → i18n;按钮 loading 态。
class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isSignup = false;
  bool _consent = false; // 知情同意默认 false,不得预勾选(§7.1)。
  bool _obscure = true;
  bool _submitting = false;

  bool get _isApplePlatform => !kIsWeb && Platform.isIOS;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  String _localeCode() => ref.read(localeControllerProvider).effective.languageCode;

  Future<void> _submit() async {
    final AppLocalizations l10n = AppLocalizations.of(context);
    if (!(_formKey.currentState?.validate() ?? false)) return;

    // 注册必须勾选同意;未勾给提示(后端亦二次校验,§4.1)。
    if (_isSignup && !_consent) {
      AppSnackbar.showMessage(context, l10n.auth_consent_required);
      return;
    }

    setState(() => _submitting = true);
    try {
      final AuthController controller = ref.read(authControllerProvider.notifier);
      if (_isSignup) {
        await controller.register(
          email: _email.text.trim(),
          password: _password.text,
          consentVersion: _kConsentVersion,
          locale: _localeCode(),
        );
      } else {
        await controller.login(email: _email.text.trim(), password: _password.text);
      }
      // 成功后由 router redirect 自动跳 Today。
    } catch (e) {
      if (mounted) AppSnackbar.showError(context, e);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  Future<void> _signInWithApple() async {
    setState(() => _submitting = true);
    try {
      final AuthorizationCredentialAppleID cred =
          await SignInWithApple.getAppleIDCredential(
        scopes: <AppleIDAuthorizationScopes>[
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      final String? fullName = <String?>[cred.givenName, cred.familyName]
          .where((String? s) => s != null && s.isNotEmpty)
          .join(' ')
          .trim()
          .nullIfEmpty();
      await ref.read(authControllerProvider.notifier).signInWithApple(
            identityToken: cred.identityToken ?? '',
            authorizationCode: cred.authorizationCode,
            fullName: fullName,
            locale: _localeCode(),
          );
    } on SignInWithAppleAuthorizationException {
      // 用户取消 Apple 授权:静默,不报错不崩溃(宪法 §1.2)。
    } catch (e) {
      if (mounted) AppSnackbar.showError(context, e);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);
    final String cta = _isSignup ? l10n.auth_signup_title : l10n.auth_login_title;
    final bool ctaEnabled = !_submitting && (!_isSignup || _consent);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppGradientBackground(
        child: SafeArea(
          child: SingleChildScrollView(
          // 顶对齐 + 适度顶部留白:logo 上移、垂直更平衡;内容仍可滚动适配小屏。
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.xl,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    // —— Logo:primaryContainer 圆形底 + 柔和阴影(视觉增强)——
                    Center(
                      child: Container(
                        width: 96,
                        height: 96,
                        decoration: BoxDecoration(
                          color: AppColors.primaryContainer,
                          shape: BoxShape.circle,
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.18),
                              blurRadius: 24,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.restaurant,
                            size: 48, color: AppColors.onPrimaryContainer),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(l10n.appTitle,
                        textAlign: TextAlign.center, style: theme.textTheme.headlineSmall),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(l10n.brandTagline,
                        textAlign: TextAlign.center, style: theme.textTheme.bodyMedium),
                    const SizedBox(height: AppSpacing.xl),

                    // —— 邮箱 ——
                    TextFormField(
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      enabled: !_submitting,
                      decoration: InputDecoration(
                        labelText: l10n.auth_field_email,
                        hintText: l10n.auth_field_emailHint,
                      ),
                      validator: (String? v) => _validateEmail(v, l10n),
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // —— 密码 ——
                    TextFormField(
                      controller: _password,
                      obscureText: _obscure,
                      enabled: !_submitting,
                      decoration: InputDecoration(
                        labelText: l10n.auth_field_password,
                        suffixIcon: IconButton(
                          onPressed: () => setState(() => _obscure = !_obscure),
                          icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
                        ),
                      ),
                      validator: (String? v) => _validatePassword(v, l10n),
                    ),

                    if (!_isSignup) ...<Widget>[
                      Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: TextButton(
                          onPressed: _submitting ? null : () {},
                          child: Text(l10n.auth_forgotPassword),
                        ),
                      ),
                    ],

                    // —— 知情同意(仅注册;默认不勾,热区≥48dp,§7.1)——
                    if (_isSignup) ...<Widget>[
                      const SizedBox(height: AppSpacing.sm),
                      _ConsentRow(
                        value: _consent,
                        onChanged: _submitting
                            ? null
                            : (bool v) => setState(() => _consent = v),
                      ),
                    ],

                    const SizedBox(height: AppSpacing.md),

                    // —— 主 CTA(注册未勾选 = disabled 灰)——
                    FilledButton(
                      onPressed: ctaEnabled ? _submit : null,
                      style: FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(AppSizes.buttonHeightCta),
                        // 胶囊主按钮加轻微浮起,按压有反馈(视觉增强)。
                        elevation: AppElevation.level2,
                      ),
                      child: _submitting
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: AppColors.onPrimary),
                            )
                          : Text(cta),
                    ),

                    // —— Apple 登录(iOS Must)——
                    if (_isApplePlatform) ...<Widget>[
                      const SizedBox(height: AppSpacing.md),
                      _OrDivider(label: l10n.auth_orDivider),
                      const SizedBox(height: AppSpacing.md),
                      SignInWithAppleButton(
                        onPressed: _submitting ? () {} : _signInWithApple,
                        style: SignInWithAppleButtonStyle.black,
                        height: AppSizes.buttonHeightCta,
                        borderRadius: BorderRadius.circular(AppRadius.full),
                      ),
                    ],

                    const SizedBox(height: AppSpacing.lg),

                    // —— 登录/注册切换 ——
                    TextButton(
                      onPressed: _submitting
                          ? null
                          : () => setState(() => _isSignup = !_isSignup),
                      child: Text(_isSignup
                          ? l10n.auth_signup_switchToLogin
                          : l10n.auth_login_switchToSignup),
                    ),
                  ],
                ),
              ),
            ),
          ),
          ),
        ),
      ),
    );
  }

  String? _validateEmail(String? v, AppLocalizations l10n) {
    final String value = (v ?? '').trim();
    // 简单格式校验(后端二次校验,§4.1)。
    final bool ok = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value);
    return ok ? null : l10n.auth_email_invalid;
  }

  String? _validatePassword(String? v, AppLocalizations l10n) {
    final String value = v ?? '';
    if (!_isSignup) {
      return value.isEmpty ? l10n.auth_field_password : null;
    }
    // 注册:≥8 含字母+数字(对齐 API §4.1)。
    final bool ok = value.length >= 8 &&
        RegExp(r'[A-Za-z]').hasMatch(value) &&
        RegExp(r'\d').hasMatch(value);
    return ok ? null : l10n.auth_password_weak;
  }
}

extension _NullIfEmpty on String {
  String? nullIfEmpty() => isEmpty ? null : this;
}

/// 同意行内联可点链接词 → 目标应用内政策路由。
class _ConsentLink {
  const _ConsentLink(this.word, this.route);
  final String word;
  final String route;
}

/// 知情同意行:Checkbox + 富文本协议链接;整行点按区 ≥48dp(§7.1)。
class _ConsentRow extends StatelessWidget {
  const _ConsentRow({required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);
    return InkWell(
      onTap: onChanged == null ? null : () => onChanged!(!value),
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: AppSizes.hitTarget),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Checkbox(
              value: value,
              onChanged: onChanged == null ? null : (bool? v) => onChanged!(v ?? false),
            ),
            Expanded(
              child: Text.rich(
                _consentSpan(context, theme, l10n),
                style: theme.textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 将整句同意文案中**内联的**「用户协议」「隐私政策」两个词本身做成可点链接
  /// (分别 push /legal/terms、/legal/privacy),不在句末重复追加独立链接(§7.1)。
  /// 实现:在 label 文本中定位两个协议名子串,切片重组为「普通文本 + 可点链接 + 普通文本」。
  /// zh 的《用户协议》《隐私政策》书名号会被保留为普通文本,仅词本身高亮可点。
  /// 注:recognizer 随 TextSpan 一同被 RichText 持有,page dispose 时一并回收,无需手动管理。
  InlineSpan _consentSpan(
      BuildContext context, ThemeData theme, AppLocalizations l10n) {
    final TextStyle linkStyle = theme.textTheme.bodyMedium!.copyWith(
        color: theme.colorScheme.primary,
        decoration: TextDecoration.underline);

    // 两个内联链接词及其各自的目标路由,按在文案中出现的位置排序后切片。
    final List<_ConsentLink> links = <_ConsentLink>[
      _ConsentLink(l10n.auth_consent_terms, AppRoutes.legalTerms),
      _ConsentLink(l10n.auth_consent_privacy, AppRoutes.legalPrivacy),
    ];

    final String label = l10n.auth_consent_label;
    final List<InlineSpan> spans = <InlineSpan>[];
    int cursor = 0;

    // 按词在 label 中的实际位置逐个切片,保证顺序与多语言文案一致。
    while (cursor < label.length) {
      int nextIndex = -1;
      _ConsentLink? nextLink;
      for (final _ConsentLink link in links) {
        if (link.word.isEmpty) continue;
        final int idx = label.indexOf(link.word, cursor);
        if (idx >= 0 && (nextIndex < 0 || idx < nextIndex)) {
          nextIndex = idx;
          nextLink = link;
        }
      }
      if (nextLink == null || nextIndex < 0) {
        spans.add(TextSpan(text: label.substring(cursor)));
        break;
      }
      if (nextIndex > cursor) {
        spans.add(TextSpan(text: label.substring(cursor, nextIndex)));
      }
      spans.add(TextSpan(
        text: nextLink.word,
        style: linkStyle,
        recognizer: TapGestureRecognizer()
          ..onTap = () => context.push(nextLink!.route),
      ));
      cursor = nextIndex + nextLink.word.length;
    }

    return TextSpan(children: spans);
  }
}

class _OrDivider extends StatelessWidget {
  const _OrDivider({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          child: Text(label, style: Theme.of(context).textTheme.bodySmall),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }
}
