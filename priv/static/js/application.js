(() => {
  class myWebsocketHandler {
    setupSocket() {
      this.socket = new WebSocket("ws://localhost:4000/ws/chat")

      this.socket.addEventListener("message", (event) => {
        const main = document.getElementById("main")

        while (main.lastChild) {
          main.removeChild(main.lastChild);
        }
        var messages = JSON.parse(event.data)
        console.log(messages)
        messages.forEach(text => {
          const pTag = document.createElement("p")
          pTag.innerHTML = text
          main.appendChild(pTag)
        })
      })

      this.socket.addEventListener("close", () => {
        this.setupSocket()
      })
    }

    submit(event) {
      event.preventDefault()
      const input = document.getElementById("message")
      const input2 = document.getElementById("username")

      const message = input.value
      const user = input2.value
      input.value = ""
      input2.value = ""

      this.socket.send(
        JSON.stringify({
          data: {message: message, user: user},
        })
      )
    }
  }

  const websocketClass = new myWebsocketHandler()
  websocketClass.setupSocket()

  document.getElementById("button")
    .addEventListener("click", (event) => websocketClass.submit(event))
})()
