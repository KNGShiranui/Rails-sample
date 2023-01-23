class CreateBlogs < ActiveRecord::Migration[6.1]
  # マイグレーションファイルのそれぞれにはクラスが定義され、ActiveRecord::Migrationクラスを継承しています。
  def change  # このchange以下の中が実行されます！
    # ちなみにだが、changeメソッドはup/downメソッドとよく似ているらしい
    create_table :blogs do |t| # この下にカラムを追加するコードを記述していきます。
    # create_table :blogs do |t|
    #   t.データ型 :カラム名
    # end
      t.string :title
      t.text :content
      t.timestamps
    end
  end
end
