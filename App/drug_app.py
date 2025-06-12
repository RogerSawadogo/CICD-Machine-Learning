import gradio as gr
import skops.io as sio

# Step 1: Get list of untrusted types from the file
untrusted_types = sio.get_untrusted_types(file="./Model/drug_pipeline.skops")

# Optional: print the untrusted types to verify they're safe
print("Untrusted types:", untrusted_types)

# Step 2: After reviewing, load the model with explicitly trusted types
pipe = sio.load("./Model/drug_pipeline.skops", trusted=untrusted_types)

# Prediction function
def predict_drug(age, sex, blood_pressure, cholesterol, na_to_k_ratio):
    features = [age, sex, blood_pressure, cholesterol, na_to_k_ratio]
    predicted_drug = pipe.predict([features])[0]
    return f"Predicted Drug: {predicted_drug}"

# Gradio UI
inputs = [
    gr.Slider(15, 74, step=1, label="Age"),
    gr.Radio(["M", "F"], label="Sex"),
    gr.Radio(["HIGH", "LOW", "NORMAL"], label="Blood Pressure"),
    gr.Radio(["HIGH", "NORMAL"], label="Cholesterol"),
    gr.Slider(6.2, 38.2, step=0.1, label="Na_to_K"),
]
outputs = gr.Label()

examples = [
    [30, "M", "HIGH", "NORMAL", 15.4],
    [35, "F", "LOW", "NORMAL", 8],
    [50, "M", "HIGH", "HIGH", 34],
]

gr.Interface(
    fn=predict_drug,
    inputs=inputs,
    outputs=outputs,
    examples=examples,
    title="Drug Classification",
    description="Enter the details to correctly identify Drug type.",
    
    theme=gr.themes.Soft(),
).launch()
