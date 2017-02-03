import React, { PropTypes } from 'react';

export default class MainArticle extends React.Component {
  static propTypes = {
    article: PropTypes.object.isRequired, // this is passed from the Rails view
    csrfParamName: PropTypes.string.isRequired,
    csrfToken: PropTypes.string.isRequired
  };

  /**
   * @param props - Comes from your rails view.
   * @param _railsContext - Comes from React on Rails
   */
  constructor(props, _railsContext) {
    super(props);


    // How to set initial state in ES6 class syntax
    // https://facebook.github.io/react/docs/reusable-components.html#es6-classes
    this.state = {
      article: {title: this.props.title, body: this.props.body, excerpt: this.props.excerpt, cover: this.props.cover}
    };
  }

  render() {
    var article = this.state.article;
    var formActionPath = Routes.articles_path();

    var prefixName = 'article';
    var inputArticleTitle = prefixName + '[title]';
    var inputArticleBody = prefixName + '[body]';
    var inputArticleExcerpt = prefixName + '[excerpt]';
    var inputArticleCover = prefixName + '[cover]';

    var list_articles = [];
    var articles = this.props.articles;

    list_articles = articles.map((article, index) =>
      <tr key={index}>
        <td>{article.title}</td>
        <td>{article.body}</td>
        <td>{article.excerpt}</td>
        <td>{article.cover}</td>
        <td><a href='javascript:void(0)' onClick={this.onEdit.bind(this, article)}>Edit</a></td>
        <td><a href='javascript:void(0)' onClick={this.onDestroy.bind(this, article)}>Destroy</a></td>
      </tr>
    );

    return (
      <div>
        <h3>lahaula walakuata illabillah</h3>
        <hr />
        <form action={formActionPath} method='post' data-type='json'>
          <input type='hidden' name={this.props.csrfParamName} value={this.props.csrfToken} />
          <p>
            <label htmlFor="title">Title :</label>
            <input type="text" id="title" name={inputArticleTitle} value={article.title} onChange={(e) => this.updateArticle(e.target.value)} />
          </p>
          <p>
            <label htmlFor="body">Body :</label>
            <textarea id="body" name={inputArticleBody} value={article.body} onChange={(e) => this.updateArticle(e.target.value)} >
            </textarea>
          </p>
            <label htmlFor="title">excerpt :</label>
            <input type="text" id="excerpt" name={inputArticleExcerpt} value={article.excerpt} onChange={(e) => this.updateArticle(e.target.value)} />
          <p>
            <label htmlFor="title">Cover :</label>
            <input type="text" id="Cover" name={inputArticleCover} value={article.cover} onChange={(e) => this.updateArticle(e.target.value)} />
          </p>
          <p>
            <button type="submit">Insert</button>
          </p>
        </form>

        <h3>Listing Articles</h3>
        <hr />
        <table>
          <thead>
            <tr>
              <th>Title</th>
              <th>Body</th>
              <th>Excerpt</th>
              <th>Cover</th>
            </tr>
          </thead>
          <tbody>
            { list_articles }
          </tbody>
        </table>
      </div>
    );
  };

  onEdit = (article) => {
    console.log(article);
  };

  updateArticle = (article) => {
    this.setState({ article });
  };

  onDestroy(article) {
    var articles = this.props.articles;

    $.ajax({
      method: 'delete',
      url: Routes.article_path(article.id),
      dataType: 'json',
      success: (function(_this) {
        return function() {
          articles.map(function(_article, index) {
            if (_article.id == article.id) {
              articles.splice(index, 1);
              _this.setState({articles: articles});
            }
          });
        };
      })(this)
    });
  };


}

