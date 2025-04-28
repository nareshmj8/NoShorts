import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noshorts/services/premium_service.dart';

// Premium state model
class PremiumState {
  final bool isPremium;
  final DateTime? expiryDate;
  final String? subscriptionType; // 'weekly', 'monthly', 'yearly'

  PremiumState({
    this.isPremium = false,
    this.expiryDate,
    this.subscriptionType,
  });

  PremiumState copyWith({
    bool? isPremium,
    DateTime? expiryDate,
    String? subscriptionType,
  }) {
    return PremiumState(
      isPremium: isPremium ?? this.isPremium,
      expiryDate: expiryDate ?? this.expiryDate,
      subscriptionType: subscriptionType ?? this.subscriptionType,
    );
  }
}

// Premium notifier class
class PremiumNotifier extends StateNotifier<PremiumState> {
  PremiumNotifier() : super(PremiumState()) {
    // Check premium status on initialization
    _checkPremiumStatus();
  }

  // Method to check initial premium status
  Future<void> _checkPremiumStatus() async {
    try {
      final statusData = await PremiumService.checkPremiumStatus();

      if (statusData['isPremium'] == true) {
        state = state.copyWith(
          isPremium: true,
          expiryDate:
              statusData['expiryDate'] != null
                  ? DateTime.parse(statusData['expiryDate'])
                  : null,
          subscriptionType: statusData['subscriptionType'],
        );
      }
    } catch (e) {
      // Handle error silently, default to non-premium
    }
  }

  // Method to upgrade to premium
  Future<void> upgradeToPremium(String subscriptionType) async {
    String productId;

    // Map subscription type to product ID
    switch (subscriptionType) {
      case 'weekly':
        productId = 'weekly_premium';
        break;
      case 'monthly':
        productId = 'monthly_premium';
        break;
      case 'yearly':
        productId = 'yearly_premium';
        break;
      default:
        throw Exception('Invalid subscription type');
    }

    // Purchase product via service
    final purchaseResult = await PremiumService.purchaseProduct(productId);

    if (purchaseResult['success'] == true) {
      state = state.copyWith(
        isPremium: true,
        expiryDate: DateTime.parse(purchaseResult['expiryDate']),
        subscriptionType: purchaseResult['subscriptionType'],
      );
    } else {
      throw Exception('Purchase failed');
    }
  }

  // Method to check if subscription is active
  void checkSubscriptionStatus() {
    if (state.expiryDate != null &&
        state.expiryDate!.isBefore(DateTime.now())) {
      // Subscription expired
      state = state.copyWith(isPremium: false, subscriptionType: null);
    }
  }

  // Method to cancel subscription
  Future<void> cancelSubscription() async {
    // Call service to cancel
    final result = await PremiumService.cancelSubscription();

    if (result) {
      state = state.copyWith(
        isPremium: false,
        expiryDate: null,
        subscriptionType: null,
      );
    } else {
      throw Exception('Failed to cancel subscription');
    }
  }
}

// Premium provider
final premiumProvider = StateNotifierProvider<PremiumNotifier, PremiumState>((
  ref,
) {
  return PremiumNotifier();
});
