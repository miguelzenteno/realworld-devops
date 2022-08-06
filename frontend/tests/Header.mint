suite "Header" {
  test "it has a logo" {
    with Test.Html {
      <Header/>
      |> start()
      |> assertElementExists("[data-selector=brand] svg")
    }
  }

  test "it has a brand name" {
    with Test.Html {
      <Header/>
      |> start()
      |> assertTextOf("span", "Conduit")
    }
  }

  test "it renders the sign in link" {
    with Test.Html {
      <Header/>
      |> start()
      |> assertTextOf("div[data-selector=links] a:first-child", "Sign in")
    }
  }

  test "it renders the sign up link" {
    with Test.Html {
      <Header/>
      |> start()
      |> assertTextOf("div[data-selector=links] a:last-child", "Sign up")
    }
  }
}
