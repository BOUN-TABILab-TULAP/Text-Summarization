from typing import Optional

import torch
import uvicorn
from datasets import Dataset
from fastapi import Request, FastAPI
from api_helper import ApiHelper
from pydantic import BaseModel


class Item(BaseModel):
    text: str
    model_name_or_path: Optional[str] = None


app = FastAPI()
api_helper = ApiHelper("batubayk/combined_tr_berturk32k_cased_summary", do_tr_lowercase=True, source_prefix="",
                       max_source_length=512,
                       max_target_length=120, num_beams=4, ngram_blocking_size=3, early_stopping=False,
                       use_cuda=torch.cuda.is_available(),
                       batch_size=1, language="tr")


@app.get("/")
def home():
    return {"Hello World!"}


@app.post("/summarize")
async def generate(item: Item):
    inp_dict = {"input": [item.text]}
    test_data = Dataset.from_dict(inp_dict)
    test_data = test_data.map(
        api_helper.preprocess_function,
        batched=True,
        load_from_cache_file=False
    )
    result = test_data.map(api_helper.generate_summary, batched=True, batch_size=api_helper.batch_size,
                           load_from_cache_file=False)

    return {"summary": result['predictions'][0]}


if __name__ == "__main__":
    uvicorn.run("api:app")
