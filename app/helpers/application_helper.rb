module ApplicationHelper
	def default_meta_tags
		{
			title: "GoodChat | 今すぐ楽しもう！",
			description: "GoodChatはアカウント無しでもチャットができる。画期的なチャットアプリです。\n自分のルームをカスタマイズすることも可能です。\nあなただけのチャットルームを作ろう",
			keywords: "Ruby,Meta,Tags",
			icon: image_url("favicon.ico"),
			charset: "UTF-8",
			og: {
				title: "GoodChat | 今すぐ楽しもう！",
				type: "website",
				url: request.original_url,
				image: image_url("good.png"),
				site_name: "GoodChat | 今すぐ楽しもう！",
				description: "GoodChatはアカウント無しでもチャットができる。画期的なチャットアプリです。\n自分のルームをカスタマイズすることも可能です。\nあなただけのチャットルームを作ろう",
				locale: "ja_JP"
			},
			twitter: {
				card: 'summary',
				site: '@YuppyHappyToYou'
			}
		}
	end
end
