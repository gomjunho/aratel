require "test_helper"

class ActiveAdminTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @admin_user = AdminUser.create!(
      email: "admin_#{SecureRandom.hex(4)}@example.com",
      password: "password",
      password_confirmation: "password"
    )
    sign_in @admin_user

    @user = User.create!(
      name: "홍길동",
      phone_number: "01012345678",
      birth_date: "19800101",
      tier: "GOLD",
      complex_name: "디에이치 방배",
      building_number: "101동",
      unit_number: "1502호"
    )
    @evidence = TierEvidence.create!(
      user: @user,
      evidence_type: "INCOME_CERT",
      document_url: "https://storage.aratel.com/docs/income_2025.pdf",
      target_tier: "DIAMOND"
    )
    @delegation = DelegatedAccessRequest.create!(
      user: @user,
      relationship: "FAMILY",
      document_url: "https://storage.aratel.com/docs/family_rel_123.pdf"
    )
    @post = LoungePost.create!(
      post_id: "post_7001",
      anonymous_nickname: "은밀한 자산가 42",
      complex_name: "디에이치 방배",
      title: "절세 노하우",
      content_encrypted: "EncryptedBodyPayload",
      clean_signal_verified: true,
      is_diamond_weighted: true,
      trust_score: 98
    )
    @club_deal = ClubDeal.create!(
      deal_id: "deal_552",
      brand: "B&B Italia",
      item_name: "Camaleonda Sofa",
      original_price: 18500000,
      deal_price: 14200000,
      point_discount_limit: 1000000,
      min_participants: 5,
      current_participants: 3,
      status: "OPEN"
    )
    @concierge = ConciergeReservation.create!(
      reservation_id: "res_7710",
      user: @user,
      service_type: "WOORI_TWO_CHAIRS",
      preferred_date: Date.today + 7.days,
      notes: "자산 증여 상담"
    )
  end

  test "should redirect unauthenticated request to admin login" do
    sign_out @admin_user
    get admin_root_path
    assert_response :redirect
    assert_redirected_to new_admin_user_session_path
  end

  test "should get active_admin dashboard when logged in" do
    get admin_root_path
    assert_response :success
  end

  test "should get active_admin users index" do
    get admin_users_path
    assert_response :success
    assert_select "td", text: "홍길동"
  end

  test "should get active_admin tier_evidences index and approve evidence" do
    get admin_tier_evidences_path
    assert_response :success

    put approve_admin_tier_evidence_path(@evidence)
    assert_redirected_to admin_tier_evidences_path
    assert_equal "VERIFIED", @evidence.reload.status
    assert_equal "DIAMOND", @user.reload.tier
  end

  test "should reject tier evidence in active_admin" do
    put reject_admin_tier_evidence_path(@evidence)
    assert_redirected_to admin_tier_evidences_path
    assert_equal "REJECTED", @evidence.reload.status
  end

  test "should get active_admin delegated_access_requests index and approve delegation" do
    get admin_delegated_access_requests_path
    assert_response :success

    put approve_admin_delegated_access_request_path(@delegation)
    assert_redirected_to admin_delegated_access_requests_path
    assert_equal "APPROVED", @delegation.reload.status
    assert_includes @user.reload.badges, "RESIDENT"
  end

  test "should reject delegated access in active_admin" do
    put reject_admin_delegated_access_request_path(@delegation)
    assert_redirected_to admin_delegated_access_requests_path
    assert_equal "REJECTED", @delegation.reload.status
  end

  test "should get active_admin lounge_posts index" do
    get admin_lounge_posts_path
    assert_response :success
    assert_select "td", text: "절세 노하우"
  end

  test "should get active_admin club_deals index" do
    get admin_club_deals_path
    assert_response :success
    assert_select "td", text: "Camaleonda Sofa"
  end

  test "should get active_admin concierge_reservations index" do
    get admin_concierge_reservations_path
    assert_response :success
  end
end
