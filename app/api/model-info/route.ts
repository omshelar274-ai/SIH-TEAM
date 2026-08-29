import { NextResponse } from "next/server";
import fs from "fs";
import path from "path";

export async function GET() {
  try {
    const basePath = path.join(process.cwd(), "sih-ml", "model");

    const frameworkInfoPath = path.join(basePath, "framework_info.json");
    const featureImportancesPath = path.join(basePath, "feature_importances.json");
    const featuresPath = path.join(basePath, "features.json");

    if (!fs.existsSync(frameworkInfoPath) || !fs.existsSync(featureImportancesPath)) {
      return NextResponse.json(
        { error: "Model metadata files not found on disk. Please run train_model.py to generate artifacts." },
        { status: 404 }
      );
    }

    const frameworkInfo = JSON.parse(fs.readFileSync(frameworkInfoPath, "utf-8"));
    const featureImportances = JSON.parse(fs.readFileSync(featureImportancesPath, "utf-8"));
    const features = fs.existsSync(featuresPath) ? JSON.parse(fs.readFileSync(featuresPath, "utf-8")) : [];

    return NextResponse.json({
      success: true,
      source: "disk_artifacts",
      frameworkInfo,
      featureImportances,
      features,
    });
  } catch (err: any) {
    return NextResponse.json(
      { error: err?.message || "Failed to load model metadata artifacts." },
      { status: 500 }
    );
  }
}
