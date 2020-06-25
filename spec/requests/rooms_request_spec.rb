require 'rails_helper'
RSpec.describe "Rooms", type: :request do
	describe "ログインしていない場合" do
		context 'index' do
			it "indexで表示できる" do
				get rooms_path
				expect(response.status).to eq 200
			end
		end

		context "new" do
			it "newにアクセスできない" do
				get new_room_path
				# to_notは　to の だめバージョン
				# to beを使えば
				expect(response.status).to_not eq 200
				expect(response.status).to be >= 300
				expect(response.status).to be < 400
			end
		end

		context 'show' do 
			it "showにアクセスできます" do
				user = User.create!(name: "USERNAME", email: "email@email", password: "nillclass")
				room = Room.create!(title: "ROOMTITLE", user_id: user.id)
				puts "-----------" + room.id.to_s
				get room_path(room.id)
				expect(response.status).to_not eq 200
				expect(response.status).to be >= 300
				expect(response.status).to be < 400
			end
		end

		context "create" do
			it "ログインしてないのでcreateできません　よって　れダイレクト！" do
				post rooms_path
				expect(response.status).to_not eq 200
				expect(response.status).to be >= 300
				expect(response.status).to be < 400
			end
		end
	end
	# describe "ログインしていた場合　ログインしていない場合　同時" do
	# 	context "index" do 
	# 		it "indexで表示できる" do
	# 			get rooms_path
	# 			expect(response.status).to eq 200
	# 		end
	# 	end

	# 	# context "show" do
	# 	# 	it "showで表示できるよ" do
	# 	# 		# get room_path
	# 	# 	end
	# 	# end
	# end
	describe "ログインしていた場合" do
		p "11111111111111111111111111"
		i = 1
		before(:each) do
			i += 1
			# factoryBotはすげーちゃちゃっと作ってくれるやつ
			# @user = create(:user)
			p "beforeのなかだよおおおおおおおおおおおおおおおおおおおおお"
			@user = User.create!(
								name: "kurotyan",
								email: "b#{i}@b",
								password: "aaaaaa")
			@user2 = User.create!(
								name: "kurotyan2",
								email: "kurotyan#{i}@kurotyan",
								password: "aaaaaa")
			# puts "----------USERUSER-----------------" + @user.id.to_s
			# puts "---------------USERUSER2------------" + @user.id.to_s
			sign_in @user
		end
			p "-------beforeEachhelp----------"

		context "new" do
			it "ログインしていたらnewにアクセスできます" do
				get new_room_path
				expect(response.status).to eq 200
			end
		end
		context "update" do
			# puts "------------" + @user.id.to_s
			it "ろぐいんしていたら自分の投稿にあくせすできます。" do
				room = Room.create!(title: "ROOMTITLE", user_id: @user.id)	
				puts "------------" + room.id.to_s
				puts "----------------" + room.to_s
				put room_path(room: room)
				expect(response.status).to eq 200
			end
			it "ログインしていたら自分以外の投稿にはupdateできない" do
				room = Room.create!(title: "ROOMTITLE", user_id: @user2.id)
				# puts "------------" + @user2.id.to_s
				puts "----------------" + room.to_s

				put room_path(room: room)
				expect(response.status).to_not eq 200 #成功しない
				expect(response.status).to be >= 300
				expect(response.status).to be < 400
			end
		end

		context "create" do
			it "ログインしていたらcreateすることができます" do
				room = Room.create!(title: "ROOMTITLE", user_id: @user.id)		
				post rooms_path(room: room)
				expect(response.status).to eq 200
			end
		end
	end
end
