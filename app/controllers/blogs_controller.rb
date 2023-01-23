class BlogsController < ApplicationController
  # before_action :set_blog, only: [:show, :edit, :update, destroy]
  # 上のコメントアウトしたbefore_actionを実行すると、それぞれのアクションに個別メソッドを定義しなくてもよくなるので便利。
  # しかし、コードの見通しが悪くなるので使用はケースバイケースで。
  # privateで設定しているset_blogにも目を通すこと。
  # before_action :set_blogとすることで、アクションのメソッドが実行される前に、指定したメソッドset_blogを実行できます。
  # また、onlyオプションというオプションを使用することで、指定されたアクションが実行された場合(ここでは　show,edit,update )のみbefore_action が実行されます。
  # これにより、各メソッドの重複箇所を削除しても、プログラムは正常に動きます。各メソッドの重複箇所を削除しましょう。
  # 今回はコメントアウトして導入していないので注意。あくまでもそういう手法もあるということの備忘録としての記録。

  def index
    @blogs = Blog.all
  end

  # 追記する。render :new が省略されている。
  def new
    @blog = Blog.new  
  end
  
  def create
    # Blog.create(title: params[:blog][:title], description: params[:blog][:content])
    # Blog.create(params.require(:blog).permit(:title, :description)) #上記のBlog.create(title: params[:blog][:title], description: params[:blog][:content])から改定strong parametersにした
    # Blog.create(blog_params)  ※上記の()内の変数を外出ししてblog_paramsとして下で定義
    @blog = Blog.new(blog_params)    # 上記のプログラムをさらに修正してmodelからのバリデーション適用
    if params[:back]
      render :new
    else
      if @blog.save
      # 一覧画面へ遷移して"ブログを作成しました！"とメッセージを表示します。
      # @blog.saveがバリデーションに許された（成功した）時 => @blog.saveの戻り値はtrueとなり、redirect_to blogs_path, notice: "ブログを作成しました！"が実行される
    # redirect_to "/blogs/new"
    # redirect_to new_blog_path  #上記のredirect_to "/blogs/new"のprefix表記。_pathを末尾につける場合は相対パス。_urlのときは絶対パス。
    # new_blog_urlの場合、https://..../blogs/newと同じ意味になります。
    # private配下にメソッドを記述すると、そのメソッドはPrivateMethodになり、そのクラス内からしか呼び出すことができなくなります。
    # 少し難しいので、他クラスから呼び出すことができなくなるので、予期せぬ結果を防ぐことができるとイメージできていればOKです。
    redirect_to blogs_path, notice: "ブログを作成しました！" #上記のリダイレクトをさらに修正してバリデーションの分岐に対応させた。noticeについてはrailsの29章参照
    # notice オプションでフィードバックメッセージを渡す。フィードバックメッセージを表示させる場所を作成する。
    # viewでnoticeを表示させること！
      else
      # 入力フォームを再描画します。
        render :new
      end
      # @blog.saveバリデーションに許されなかった（失敗した）時  => @blog.saveの戻り値はfalseとなり、 render :new が実行される
      # create.html.erbなどは存在しないので、そのまま放っておくとエラーが起きてしまいます。
      # そこで、renderメソッドを使用することで、createアクションで呼び出すViewをnew.html.erbに変更できます。
      # `redirect_to` は指定したURLにアクセス（一からデータすべての取得し直し）をする。
      # `render` は指定したViewをレンダリング（データなどの状態はそのままで画面だけ貼り替え）をする。
    end


  end

  def show
    @blog = Blog.find(params[:id]) 
    # params[:id]で:idをパラメータで取得。そのidのblogをさがすために、Blog.findの引数にした。
    # ただ、このままだとviewに取得したデータが渡されない（実はこの辺あまり理解していない）ため、@blogにそれを代入してインスタンス変数として使用
    # たぶん、view（show.html.erb）の方ではタイトルが「@blog.title」となっているから、@blogというインスタンス変数にBlog.find(params[:id])を代入し、
    # @blog = Blog.find(params[:id])とする必要があるということだと思う。
  end

  def edit    #privateの下に入れたらエラーになった。こういうエラーはありがちな気がするので注意しよう。
    @blog = Blog.find(params[:id])
  end

  def update    #privateの下に入れたらエラーになった。こういうエラーはありがちな気がするので注意しよう。
    @blog = Blog.find(params[:id])
    if @blog.update(blog_params)
      redirect_to blogs_path, notice: "ブログを編集しました！"
    else
      render :edit
    end
  end

  def destroy
    @blog = Blog.find(params[:id])
    @blog.destroy #アクション名のdestroyとは異なり、こちらはモデルに対してのメソッドです。
    redirect_to blogs_path, notice:"ブログを削除しました！"
  end

  def confirm
    @blog = Blog.new(blog_params)
    render :new if @blog.invalid?      #
  end
  
  private #Strong Parameters 以外のメソッドは private よりも上に記述しましょう。
  def blog_params #blog_paramsとして、メソッドを定義し、それを呼び出すことで、いろいろな場所からの利用を可能にしています。また、privateメソッドの配下に設定して呼び出すようにしております。
      params.require(:blog).permit(:title, :description)
  end

 # 以下でidをキーとして値を取得するメソッドを追加　※たぶんこれはbefore_actionの設定に必要な下準備。詳しくはrails入門27参照。
  # def set_blog
    # @blog = Blog.find(params[:id])
  # end

end