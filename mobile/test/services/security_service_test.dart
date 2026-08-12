import 'package:flutter_test/flutter_test.dart';
import 'package:aratel_mobile/services/security_service.dart';

void main() {
  group('SecurityService Unit Tests', () {
    late SecurityService securityService;

    setUp(() {
      securityService = SecurityService();
    });

    test('Default security settings are enabled', () {
      expect(securityService.isScreenCapturePrevented, true);
      expect(securityService.isPrivacyMasked, true);
    });

    test('Toggle screen capture prevention', () async {
      await securityService.setScreenCapturePrevention(false);
      expect(securityService.isScreenCapturePrevented, false);

      await securityService.setScreenCapturePrevention(true);
      expect(securityService.isScreenCapturePrevented, true);
    });

    test('Toggle privacy masking', () async {
      await securityService.setPrivacyMasking(false);
      expect(securityService.isPrivacyMasked, false);

      await securityService.setPrivacyMasking(true);
      expect(securityService.isPrivacyMasked, true);
    });

    test('maskName utility', () {
      expect(securityService.maskName('홍길동'), '홍*동');
      expect(securityService.maskName('김철'), '김*');
      expect(securityService.maskName('A'), 'A');
      expect(securityService.maskName('남궁민수'), '남**수');
    });

    test('maskPhoneNumber utility', () {
      expect(securityService.maskPhoneNumber('01012345678'), '010-****-5678');
      expect(securityService.maskPhoneNumber('010-1234-5678'), '010-****-5678');
      expect(securityService.maskPhoneNumber('123'), '123');
    });

    test('maskUnitNumber utility', () {
      expect(securityService.maskUnitNumber('1502호'), '****호');
      expect(securityService.maskUnitNumber('101동 1502호'), '101동 ****호');
      expect(securityService.maskUnitNumber('1502'), '****');
    });
  });
}
