Vue.use(vuescroll);

var transactionApp = new Vue({
    el: '#transactionApp',
    data: {
        transactions: [],
        amount: 0.00,
        type: 'credit',
        balance: 0.00,
        errorMessage: null,
        ops: {
            rail: {
                opacity: '0.2',
                background: '#F92672',
                border: '0px',
                size: '6px'
            },
            bar: {
                background: '#f7f1f1',
                keepShow: false,
                size: '6px',
                minSize: 0.2
            },
            scrollButton: {
                enable: false,
                background: '#cecece'
            },
            scrollPanel: {
                easing: 'easeInQuad',
                speed: 800
            },
            vuescroll: {
                wheelScrollDuration: 0,
                wheelDirectionReverse: false
            }
        }
    },
    mounted() {
        this.getTransactions();

    },
    methods: {
        getClass: function (type) {
            if (type == 'debit') return 'negative-trans'

            return 'positive-trans'
        },
        formatPrice: function (number) {
            let val = (number / 1).toFixed(2);
            return val.toString().replace(/\B(?=(\d{3})+(?!\d))/g, " ");
        },
        getTransactions: function () {

            const url = "../transactions";

            const opts = {
                method: "GET",
                headers: {"Content-Type": "application/json"}
            };

            fetch(url, opts)
                .then(res => res.json())
                .then(res => {
                    console.log(res)
                    this.transactions = res
                })
                .catch(console.error);
        },
        addTransaction: function () {
            const url = "../transactions";

            const opts = {
                method: "POST",
                headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                body: `amount=${this.amount}&type=${this.type}`,
            };

            fetch(url, opts).then(function (response) {
                if (response.status === 400) {
                    response.json().then(function (object) {
                        this.transactionApp.errorMessage = object.error;
                    })
                } else if (response.status === 200) {
                    response.json().then(function (object) {
                        this.transactionApp.errorMessage = "Success! Your new balance is: $ " + object.balance;
                        this.transactionApp.balance = object.balance;
                    }).then(function (res) {
                        this.transactionApp.getTransactions();
                    })
                }
            })
        }
    }
});