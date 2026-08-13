ActiveAdmin.register CommunityPost do
  menu priority: 6, label: "💬 커뮤니티 게시판 관리"

  permit_params :board_type, :complex_name, :building_number, :nickname, :is_anonymous, :title, :content, :user_id

  index title: "💬 입주민 커뮤니티 게시판 관리" do
    selectable_column
    id_column
    column "게시판 유형" do |post|
      case post.board_type
      when "GLOBAL"
        status_tag "전체 공동", class: "ok"
      when "COMPLEX_NAMED"
        status_tag "단지별 기명", class: "warn"
      when "COMPLEX_ANONYMOUS"
        status_tag "단지별 익명", class: "error"
      else
        post.board_type
      end
    end
    column "소속 단지", :complex_name
    column "작성자 표기" do |post|
      post.author_display_name
    end
    column "제목", :title
    column "작성일시", :created_at
    actions
  end

  filter :board_type, as: :select, collection: [["전체 공동 게시판", "GLOBAL"], ["단지별 기명 게시판", "COMPLEX_NAMED"], ["단지별 익명 게시판", "COMPLEX_ANONYMOUS"]]
  filter :complex_name
  filter :title
  filter :created_at

  form do |f|
    f.inputs "게시글 상세 정보" do
      f.input :board_type, as: :select, collection: [["전체 공동 게시판", "GLOBAL"], ["단지별 기명 게시판", "COMPLEX_NAMED"], ["단지별 익명 게시판", "COMPLEX_ANONYMOUS"]]
      f.input :complex_name
      f.input :building_number
      f.input :nickname
      f.input :is_anonymous
      f.input :title
      f.input :content
    end
    f.actions
  end
end
