## How to run using Docker
1. Clone the repo
```bash
git clone https://github.com/BOUN-TABILab-TULAP/Text-Summarization.git
```
2. Launch a terminal in the root directory of the repo and build the Docker image where
- `-t` is the tag for the Docker image. You can provide any name you want
- `.` is the relative path to the Dockerfile 
```bash
docker build -t text-summarization .
```
3. Run the Docker image where
- `-d` indicates "detach", let the container run in the background
- `-p 5000:80` indicates mapping port 80 of the container to the port 5000 of the host.
```bash
docker run -d -p 5000:80 text-summarization
```
4. Send a POST request
- via curl
    ```bash
    curl -X POST http://localhost:5000/summarize 
   -H 'Content-Type: application/json' 
   -d '{"text":"Danimarka Göçmenlik Bakanı Mattias Tesfaye, Danimarka'\''nın göçmenlerin transferi konusunda Ruanda ile görüştüğünü açıkladı. Tesfaye, Danimarka'\''daki sığınmacıları Doğu Afrika ülkesi Ruanda'\''ya transfer etmek için yeni bir mekanizma kurma konusunda temaslarda bulunduklarını belirtti. Ruanda ile henüz bir anlaşma yapılmadığını söyleyen Tesfaye, parlamentodaki göçmenlik sözcüleriyle gelecek hafta bir toplantı yapılacağını duyurdu. Danimarka, geçen yıl topraklarına gelen sığınmacıları farklı bir ülkedeki sığınma merkezine taşınmasına izin veren bir yasa çıkarmıştı, Tunus ve Etiyopya gibi ülkelere potansiyel bir sığınma anlaşması için başvurularda bulunmuş ancak bir aşama kaydedilememişti. İngiltere geçen hafta, Ruanda ile insan kaçakçılığı ağlarını kırmayı ve göçmen akışını durdurmayı amaçlayan yeni bir anlaşma imzalamıştı. Anlaşma kapsamında İngiltere, ülkesine kaçak yollarla gelen binlerce sığınmacıyı Ruanda'\''ya yerleştirmeyi planladığını duyurmuştu."}'

   > {'summary': "danimarka göçmenlik bakanı mattias tesfaye, danimarka'daki sığınmacıları doğu afrika ülkesi ruanda'ya transfer etmek için yeni bir mekanizma kurma konusunda görüştüğünü açıkladı."}
    ```
- via Python's requests library
    ```python
    import requests
    res = requests.post('http://localhost:5000/summarize', json={'text':"Danimarka Göçmenlik Bakanı Mattias Tesfaye, Danimarka'nın göçmenlerin transferi konusunda Ruanda ile görüştüğünü açıkladı. Tesfaye, Danimarka'daki sığınmacıları Doğu Afrika ülkesi Ruanda'ya transfer etmek için yeni bir mekanizma kurma konusunda temaslarda bulunduklarını belirtti. Ruanda ile henüz bir anlaşma yapılmadığını söyleyen Tesfaye, parlamentodaki göçmenlik sözcüleriyle gelecek hafta bir toplantı yapılacağını duyurdu. Danimarka, geçen yıl topraklarına gelen sığınmacıları farklı bir ülkedeki sığınma merkezine taşınmasına izin veren bir yasa çıkarmıştı, Tunus ve Etiyopya gibi ülkelere potansiyel bir sığınma anlaşması için başvurularda bulunmuş ancak bir aşama kaydedilememişti. İngiltere geçen hafta, Ruanda ile insan kaçakçılığı ağlarını kırmayı ve göçmen akışını durdurmayı amaçlayan yeni bir anlaşma imzalamıştı. Anlaşma kapsamında İngiltere, ülkesine kaçak yollarla gelen binlerce sığınmacıyı Ruanda'ya yerleştirmeyi planladığını duyurmuştu."})
    print(res.json())

    > {'summary': "danimarka göçmenlik bakanı mattias tesfaye, danimarka'daki sığınmacıları doğu afrika ülkesi ruanda'ya transfer etmek için yeni bir mekanizma kurma konusunda görüştüğünü açıkladı."}
    ```